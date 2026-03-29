import * as React from 'react';
import { View, ScrollView, Pressable, StyleSheet } from 'react-native';
import { Link, useRouter } from 'expo-router';
import { useFocusEffect } from '@react-navigation/native';
import { ChevronRight, Compass, Pin, Sparkles, Timer } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';
import { useSafeAreaInsets } from 'react-native-safe-area-context';

import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { TOOL_CATALOG, TOOL_MAP } from '@/lib/tool-catalog';
import {
  getMostUsedTools,
  getPinnedTools,
  getRecentTools,
  POMODORO_STATE_KEY,
  safeStorageGetItem,
  subscribeUsageChanges,
  togglePinnedTool,
  ToolSummary,
  ToolUsageSummary,
} from '@/lib/usage';

const RECENT_LIMIT = 5;
const PINNED_LIMIT = 8;

type PomodoroSnapshot = {
  focusMinutes: number;
  breakMinutes: number;
  completedCount: number;
};

function parsePomodoroSnapshot(raw: string | null): PomodoroSnapshot | null {
  if (!raw) return null;

  try {
    const parsed = JSON.parse(raw) as Partial<PomodoroSnapshot>;
    const focusMinutes = Number(parsed.focusMinutes || 25);
    const breakMinutes = Number(parsed.breakMinutes || 5);
    const completedCount = Number(parsed.completedCount || 0);

    if (!Number.isFinite(focusMinutes) || !Number.isFinite(breakMinutes) || !Number.isFinite(completedCount)) {
      return null;
    }

    return {
      focusMinutes: Math.max(1, Math.round(focusMinutes)),
      breakMinutes: Math.max(1, Math.round(breakMinutes)),
      completedCount: Math.max(0, Math.round(completedCount)),
    };
  } catch {
    return null;
  }
}

export default function IndexScreen() {
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';
  const insets = useSafeAreaInsets();
  const router = useRouter();

  const [pinnedTools, setPinnedTools] = React.useState<ToolSummary[]>([]);
  const [recentTools, setRecentTools] = React.useState<ToolSummary[]>([]);
  const [recommendedTools, setRecommendedTools] = React.useState<ToolUsageSummary[]>([]);
  const [pomodoroSnapshot, setPomodoroSnapshot] = React.useState<PomodoroSnapshot | null>(null);

  const loadHomeData = React.useCallback(async () => {
    const [pinned, recent, recommended, pomodoroRaw] = await Promise.all([
      getPinnedTools(PINNED_LIMIT),
      getRecentTools(RECENT_LIMIT),
      getMostUsedTools(3, 7),
      safeStorageGetItem(POMODORO_STATE_KEY),
    ]);

    setPinnedTools(pinned);
    setRecentTools(recent);
    setRecommendedTools(recommended);
    setPomodoroSnapshot(parsePomodoroSnapshot(pomodoroRaw));
  }, []);

  useFocusEffect(
    React.useCallback(() => {
      loadHomeData();
    }, [loadHomeData])
  );

  React.useEffect(() => {
    const unsubscribe = subscribeUsageChanges(loadHomeData);
    return unsubscribe;
  }, [loadHomeData]);

  const pinnedToolIdSet = React.useMemo(() => new Set(pinnedTools.map((tool) => tool.id)), [pinnedTools]);

  const handleTogglePin = React.useCallback(async (tool: Pick<ToolSummary, 'id'>) => {
    await togglePinnedTool(tool.id);
  }, []);

  const recommendedVisible = React.useMemo(() => {
    return recommendedTools.filter((tool) => !pinnedToolIdSet.has(tool.id)).slice(0, 3);
  }, [recommendedTools, pinnedToolIdSet]);

  const showPomodoroContinue = React.useMemo(() => {
    if (!pomodoroSnapshot) return false;
    return (
      pomodoroSnapshot.completedCount > 0 ||
      pomodoroSnapshot.focusMinutes !== 25 ||
      pomodoroSnapshot.breakMinutes !== 5
    );
  }, [pomodoroSnapshot]);

  return (
    <ScrollView className="flex-1 bg-background" showsVerticalScrollIndicator={false} contentContainerStyle={{ paddingBottom: 92 }}>
      <View className="px-5 pb-2" style={{ paddingTop: insets.top + 12 }}>
        <Text className="text-[30px] font-bold text-foreground tracking-tight leading-9">主页</Text>
      </View>

      <View className="px-5 gap-4">
        <View>
          <View className="flex-row items-center justify-between mb-2">
            <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">置顶工具</Text>
            <Text className="text-[12px] font-medium text-primary">长按卡片可取消</Text>
          </View>

          {pinnedTools.length > 0 ? (
            <ScrollView horizontal showsHorizontalScrollIndicator={false} className="-mx-1">
              <View className="flex-row gap-[10px] px-1">
                {pinnedTools.map((tool) => (
                  <RecentToolCard key={tool.id} tool={{ ...tool, isPinned: true }} onTogglePin={handleTogglePin} />
                ))}
              </View>
            </ScrollView>
          ) : (
            <View
              className="rounded-[11px] px-3.5 py-3"
              style={{
                backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
                borderWidth: 1,
                borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
              }}
            >
              <Text className="text-[12px] text-muted-foreground">在下方“工具捷径”里长按任意工具即可 Pin 到主页。</Text>
            </View>
          )}
        </View>

        <View>
          <View className="flex-row items-center justify-between mb-2">
            <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">最近使用</Text>
            <Text className="text-[12px] font-medium text-primary">按使用记录排序</Text>
          </View>

          <ScrollView horizontal showsHorizontalScrollIndicator={false} className="-mx-1">
            <View className="flex-row gap-[10px] px-1">
              {recentTools.map((tool) => (
                <RecentToolCard
                  key={tool.id}
                  tool={{
                    ...tool,
                    isPinned: pinnedToolIdSet.has(tool.id),
                  }}
                  onTogglePin={handleTogglePin}
                />
              ))}
            </View>
          </ScrollView>
        </View>

        {showPomodoroContinue ? (
          <View
            className="rounded-[12px] p-4"
            style={{
              backgroundColor: isDark ? 'rgba(239, 68, 68, 0.12)' : 'rgba(239, 68, 68, 0.08)',
              borderWidth: 1,
              borderColor: isDark ? 'rgba(239, 68, 68, 0.24)' : 'rgba(239, 68, 68, 0.16)',
            }}
          >
            <View className="flex-row items-center justify-between gap-3">
              <View className="flex-row items-center gap-2.5 flex-1">
                <View className="w-8 h-8 rounded-[8px] items-center justify-center" style={{ backgroundColor: 'rgba(239, 68, 68, 0.18)' }}>
                  <Icon as={Timer} color="#EF4444" size={16} strokeWidth={2.3} />
                </View>
                <View className="flex-1">
                  <Text className="text-[13px] font-semibold text-foreground">继续任务：{TOOL_MAP.pomodoro.title}</Text>
                  <Text className="text-[12px] text-muted-foreground mt-0.5">
                    专注 {pomodoroSnapshot?.focusMinutes} 分钟 · 休息 {pomodoroSnapshot?.breakMinutes} 分钟 · 已完成 {pomodoroSnapshot?.completedCount} 个周期
                  </Text>
                </View>
              </View>
              <Pressable
                className="px-3 py-2 rounded-[8px] active:opacity-80"
                style={{ backgroundColor: isDark ? 'rgba(239,68,68,0.22)' : 'rgba(239,68,68,0.16)' }}
                onPress={() => router.push('/tools/pomodoro')}
              >
                <Text className="text-[12px] font-semibold" style={{ color: '#EF4444' }}>
                  继续
                </Text>
              </Pressable>
            </View>
          </View>
        ) : null}

        {recommendedVisible.length > 0 ? (
          <View>
            <View className="flex-row items-center justify-between mb-2">
              <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">智能推荐</Text>
              <Text className="text-[12px] font-medium text-primary">最近 7 天高频</Text>
            </View>
            <View
              className="rounded-[11px] overflow-hidden"
              style={{
                backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
                borderWidth: 1,
                borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
              }}
            >
              {recommendedVisible.map((tool, index) => (
                <Pressable
                  key={tool.id}
                  className="active:bg-accent/50"
                  onPress={() => router.push(tool.pageUrl as any)}
                  onLongPress={() => {
                    handleTogglePin(tool).catch(() => {});
                  }}
                  delayLongPress={260}
                >
                  <View className="flex-row items-center px-4 min-h-[50px]">
                    <View className="w-[32px] h-[32px] rounded-[8px] items-center justify-center mr-3" style={{ backgroundColor: tool.color + '18' }}>
                      <Icon as={tool.icon} color={tool.color} size={16} strokeWidth={2.2} />
                    </View>
                    <View
                      className="flex-1 flex-row items-center justify-between py-[10px]"
                      style={
                        index !== recommendedVisible.length - 1
                          ? {
                              borderBottomWidth: StyleSheet.hairlineWidth,
                              borderBottomColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)',
                            }
                          : {}
                      }
                    >
                      <View className="flex-1">
                        <Text className="text-[14px] font-semibold text-foreground">{tool.title}</Text>
                        <Text className="text-[12px] text-muted-foreground mt-0.5">近 7 天使用 {tool.useCount} 次</Text>
                      </View>
                      <Icon as={ChevronRight} className="text-muted-foreground/30 ml-1" size={16} strokeWidth={2.5} />
                    </View>
                  </View>
                </Pressable>
              ))}
            </View>
          </View>
        ) : null}

        <View className="flex-row gap-3">
          <Pressable
            className="flex-1 rounded-[11px] p-3.5 active:opacity-85"
            style={{
              backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
              borderWidth: 1,
              borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
            }}
            onPress={() => router.push('/explore')}
          >
            <View className="flex-row items-center gap-2.5">
              <Icon as={Compass} color={isDark ? '#9CA3AF' : '#6B7280'} size={16} strokeWidth={2.2} />
              <Text className="text-[13px] font-semibold text-foreground">进入工具箱</Text>
            </View>
          </Pressable>
          <Pressable
            className="flex-1 rounded-[11px] p-3.5 active:opacity-85"
            style={{
              backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
              borderWidth: 1,
              borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
            }}
            onPress={() => router.push('/tools/news')}
          >
            <View className="flex-row items-center gap-2.5">
              <Icon as={Sparkles} color={isDark ? '#9CA3AF' : '#6B7280'} size={16} strokeWidth={2.2} />
              <Text className="text-[13px] font-semibold text-foreground">查看热搜</Text>
            </View>
          </Pressable>
        </View>

        <View>
          <View className="flex-row items-center justify-between mb-2">
            <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">工具捷径</Text>
            <Text className="text-[12px] font-medium text-primary">点击打开，长按置顶</Text>
          </View>
          <View className="flex-row flex-wrap gap-2">
            {TOOL_CATALOG.map((tool) => {
              const pinned = pinnedToolIdSet.has(tool.id);
              return (
                <Pressable
                  key={tool.id}
                  className="w-[48.5%] rounded-[10px] px-3 py-2.5 active:opacity-80"
                  style={{
                    backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
                    borderWidth: 1,
                    borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
                  }}
                  onPress={() => router.push(tool.pageUrl as any)}
                  onLongPress={() => {
                    handleTogglePin(tool).catch(() => {});
                  }}
                  delayLongPress={260}
                >
                  <View className="flex-row items-center justify-between">
                    <View className="flex-row items-center gap-2">
                      <View className="w-7 h-7 rounded-[7px] items-center justify-center" style={{ backgroundColor: tool.color + '1A' }}>
                        <Icon as={tool.icon} color={tool.color} size={14} strokeWidth={2.2} />
                      </View>
                      <Text className="text-[13px] font-medium text-foreground">{tool.title}</Text>
                    </View>
                    {pinned ? <Icon as={Pin} color={tool.color} size={12} strokeWidth={2.5} /> : null}
                  </View>
                </Pressable>
              );
            })}
          </View>
        </View>
      </View>
    </ScrollView>
  );
}

function RecentToolCard({
  tool,
  onTogglePin,
}: {
  tool: ToolSummary;
  onTogglePin: (tool: ToolSummary) => Promise<void>;
}) {
  return (
    <Link href={tool.pageUrl as any} asChild>
      <Pressable
        className="active:opacity-80"
        style={{ width: 124 }}
        onLongPress={() => {
          onTogglePin(tool).catch(() => {});
        }}
        delayLongPress={260}
      >
        <View
          className="rounded-[11px] p-[14px] h-[116px] justify-between"
          style={{
            backgroundColor: tool.gradient[0],
            shadowColor: tool.gradient[0],
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: 0.3,
            shadowRadius: 8,
            elevation: 6,
          }}
        >
          <View className="flex-row items-start justify-between">
            <View className="w-[34px] h-[34px] rounded-[9px] items-center justify-center" style={{ backgroundColor: 'rgba(255,255,255,0.2)' }}>
              <Icon as={tool.icon} className="text-white" size={19} strokeWidth={2} />
            </View>
            {tool.isPinned ? (
              <View className="px-1.5 py-0.5 rounded-[6px]" style={{ backgroundColor: 'rgba(255,255,255,0.24)' }}>
                <View className="flex-row items-center gap-1">
                  <Icon as={Pin} className="text-white" size={10} strokeWidth={2.5} />
                  <Text className="text-white text-[10px] font-semibold">置顶</Text>
                </View>
              </View>
            ) : null}
          </View>
          <View>
            <Text className="text-white font-bold text-[14px]">{tool.title}</Text>
            <Text className="text-white/70 text-[12px] mt-0.5">{tool.description}</Text>
          </View>
        </View>
      </Pressable>
    </Link>
  );
}
