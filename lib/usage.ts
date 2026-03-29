import AsyncStorage from '@react-native-async-storage/async-storage';

import { DEFAULT_RECENT_TOOL_IDS, TOOL_MAP, ToolId, ToolMeta } from '@/lib/tool-catalog';

const USAGE_LOG_KEY = '@pocket-toolkit/usage-log';
const POMODORO_STATE_KEY = '@pocket-toolkit/pomodoro-state';
const MAX_USAGE_LOG_COUNT = 100;

const APP_DATA_KEYS = [USAGE_LOG_KEY, POMODORO_STATE_KEY] as const;
const memoryFallbackStorage = new Map<string, string>();

type UsageChangeListener = () => void;

const usageListeners = new Set<UsageChangeListener>();

export type UsageLogEntry = {
  toolId: ToolId;
  openedAt: string;
};

export type ToolSummary = ToolMeta & {
  lastOpenedAt?: string;
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

async function readUsageLog(): Promise<UsageLogEntry[]> {
  const raw = await safeStorageGetItem(USAGE_LOG_KEY);
  return parseUsageLog(raw);
}

async function writeUsageLog(entries: UsageLogEntry[]) {
  await safeStorageSetItem(USAGE_LOG_KEY, JSON.stringify(entries));
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

export async function clearAppData(): Promise<void> {
  await safeStorageRemoveMany([...APP_DATA_KEYS]);
  notifyUsageChanged();
}

export { POMODORO_STATE_KEY };
