import AsyncStorage from '@react-native-async-storage/async-storage';

import { DEFAULT_RECENT_TOOL_IDS, TOOL_MAP, ToolId, ToolMeta } from '@/lib/tool-catalog';

const USAGE_LOG_KEY = '@pocket-toolkit/usage-log';
const POMODORO_STATE_KEY = '@pocket-toolkit/pomodoro-state';
const PINNED_TOOL_IDS_KEY = '@pocket-toolkit/pinned-tool-ids';
const MAX_USAGE_LOG_COUNT = 100;

const APP_DATA_KEYS = [USAGE_LOG_KEY, POMODORO_STATE_KEY, PINNED_TOOL_IDS_KEY] as const;
const memoryFallbackStorage = new Map<string, string>();

type UsageChangeListener = () => void;

const usageListeners = new Set<UsageChangeListener>();

export type UsageLogEntry = {
  toolId: ToolId;
  openedAt: string;
};

export type ToolSummary = ToolMeta & {
  lastOpenedAt?: string;
  isPinned?: boolean;
};

export type ToolUsageSummary = ToolSummary & {
  useCount: number;
};

export type UsageStats = {
  weeklyCount: number;
  totalToolsUsed: number;
  topToolId?: ToolId;
  lastOpenedAt?: string;
};

function notifyUsageChanged() {
  usageListeners.forEach((listener) => listener());
}

function isAsyncStorageUnavailable(error: unknown) {
  const message = error instanceof Error ? error.message : String(error || '');
  return message.includes('Native module is null') || message.includes('cannot access legacy storage');
}

export async function safeStorageGetItem(key: string): Promise<string | null> {
  try {
    return await AsyncStorage.getItem(key);
  } catch (error) {
    if (isAsyncStorageUnavailable(error)) {
      return memoryFallbackStorage.get(key) ?? null;
    }
    throw error;
  }
}

export async function safeStorageSetItem(key: string, value: string): Promise<void> {
  try {
    await AsyncStorage.setItem(key, value);
  } catch (error) {
    if (isAsyncStorageUnavailable(error)) {
      memoryFallbackStorage.set(key, value);
      return;
    }
    throw error;
  }
}

export async function safeStorageRemoveMany(keys: string[]): Promise<void> {
  try {
    await AsyncStorage.multiRemove(keys);
  } catch (error) {
    if (!isAsyncStorageUnavailable(error)) {
      throw error;
    }
  }

  keys.forEach((key) => {
    memoryFallbackStorage.delete(key);
  });
}

function isValidToolId(value: string): value is ToolId {
  return value in TOOL_MAP;
}

function parseUsageLog(raw: string | null): UsageLogEntry[] {
  if (!raw) return [];

  try {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];

    return parsed
      .map((item) => {
        if (!item || typeof item !== 'object') return null;
        const toolId = String((item as any).toolId || '');
        const openedAt = String((item as any).openedAt || '');

        if (!isValidToolId(toolId)) return null;
        if (!openedAt || Number.isNaN(new Date(openedAt).getTime())) return null;

        return { toolId, openedAt } satisfies UsageLogEntry;
      })
      .filter((item): item is UsageLogEntry => Boolean(item));
  } catch {
    return [];
  }
}

function parseToolIdList(raw: string | null): ToolId[] {
  if (!raw) return [];

  try {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];

    const seen = new Set<ToolId>();
    const result: ToolId[] = [];
    for (const item of parsed) {
      const toolId = String(item || '');
      if (!isValidToolId(toolId)) continue;
      if (seen.has(toolId)) continue;
      seen.add(toolId);
      result.push(toolId);
    }
    return result;
  } catch {
    return [];
  }
}

async function readUsageLog(): Promise<UsageLogEntry[]> {
  const raw = await safeStorageGetItem(USAGE_LOG_KEY);
  return parseUsageLog(raw);
}

async function writeUsageLog(entries: UsageLogEntry[]) {
  await safeStorageSetItem(USAGE_LOG_KEY, JSON.stringify(entries));
}

async function readPinnedToolIds(): Promise<ToolId[]> {
  const raw = await safeStorageGetItem(PINNED_TOOL_IDS_KEY);
  return parseToolIdList(raw);
}

async function writePinnedToolIds(toolIds: ToolId[]) {
  await safeStorageSetItem(PINNED_TOOL_IDS_KEY, JSON.stringify(toolIds));
}

export function subscribeUsageChanges(listener: UsageChangeListener) {
  usageListeners.add(listener);
  return () => {
    usageListeners.delete(listener);
  };
}

export async function recordToolOpen(toolId: ToolId): Promise<void> {
  const now = new Date().toISOString();
  const current = await readUsageLog();
  const next = [{ toolId, openedAt: now }, ...current].slice(0, MAX_USAGE_LOG_COUNT);

  await writeUsageLog(next);
  notifyUsageChanged();
}

export async function getRecentTools(limit: number): Promise<ToolSummary[]> {
  const log = await readUsageLog();
  const seen = new Set<ToolId>();
  const result: ToolSummary[] = [];

  for (const entry of log) {
    if (seen.has(entry.toolId)) continue;
    seen.add(entry.toolId);

    result.push({
      ...TOOL_MAP[entry.toolId],
      lastOpenedAt: entry.openedAt,
    });

    if (result.length >= limit) return result;
  }

  for (const toolId of DEFAULT_RECENT_TOOL_IDS) {
    if (seen.has(toolId)) continue;
    result.push({ ...TOOL_MAP[toolId] });
    if (result.length >= limit) break;
  }

  return result;
}

export async function getPinnedTools(limit?: number): Promise<ToolSummary[]> {
  const pinnedToolIds = await readPinnedToolIds();
  const result: ToolSummary[] = [];
  const maxCount = typeof limit === 'number' ? Math.max(0, limit) : Number.POSITIVE_INFINITY;

  for (const toolId of pinnedToolIds) {
    result.push({
      ...TOOL_MAP[toolId],
      isPinned: true,
    });
    if (result.length >= maxCount) break;
  }

  return result;
}

export async function togglePinnedTool(toolId: ToolId): Promise<void> {
  const current = await readPinnedToolIds();
  const exists = current.includes(toolId);
  const next = exists ? current.filter((id) => id !== toolId) : [toolId, ...current];

  await writePinnedToolIds(next);
  notifyUsageChanged();
}

export async function getUsageStats(range: 'week' | 'all' = 'all'): Promise<UsageStats> {
  const log = await readUsageLog();
  const weeklyStart = Date.now() - 7 * 24 * 60 * 60 * 1000;

  const weeklyEntries = log.filter((entry) => new Date(entry.openedAt).getTime() >= weeklyStart);
  const scopedEntries = range === 'week' ? weeklyEntries : log;

  const frequency = new Map<ToolId, number>();
  for (const entry of scopedEntries) {
    frequency.set(entry.toolId, (frequency.get(entry.toolId) || 0) + 1);
  }

  let topToolId: ToolId | undefined;
  let topCount = 0;
  frequency.forEach((count, toolId) => {
    if (count > topCount) {
      topCount = count;
      topToolId = toolId;
    }
  });

  return {
    weeklyCount: weeklyEntries.length,
    totalToolsUsed: new Set(log.map((entry) => entry.toolId)).size,
    topToolId,
    lastOpenedAt: log[0]?.openedAt,
  };
}

export async function getMostUsedTools(limit: number, recentDays = 7): Promise<ToolUsageSummary[]> {
  if (limit <= 0) return [];

  const log = await readUsageLog();
  const rangeStart = Date.now() - recentDays * 24 * 60 * 60 * 1000;
  const frequency = new Map<ToolId, number>();
  const latestOpenTime = new Map<ToolId, string>();

  for (const entry of log) {
    const openedTs = new Date(entry.openedAt).getTime();
    if (openedTs < rangeStart) continue;

    frequency.set(entry.toolId, (frequency.get(entry.toolId) || 0) + 1);
    if (!latestOpenTime.has(entry.toolId)) {
      latestOpenTime.set(entry.toolId, entry.openedAt);
    }
  }

  const rankedToolIds = [...frequency.entries()]
    .sort((a, b) => b[1] - a[1])
    .slice(0, limit)
    .map(([toolId]) => toolId);

  return rankedToolIds.map((toolId) => ({
    ...TOOL_MAP[toolId],
    useCount: frequency.get(toolId) || 0,
    lastOpenedAt: latestOpenTime.get(toolId),
  }));
}

export async function clearAppData(): Promise<void> {
  await safeStorageRemoveMany([...APP_DATA_KEYS]);
  notifyUsageChanged();
}

export { POMODORO_STATE_KEY };
