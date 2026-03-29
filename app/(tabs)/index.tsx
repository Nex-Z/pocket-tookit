import * as React from 'react';
import { View, ScrollView, Pressable, StyleSheet } from 'react-native';
import { Link } from 'expo-router';
import { useFocusEffect } from '@react-navigation/native';
import { ChevronRight, Sparkles } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { TOOL_CATALOG, TOOL_CATEGORIES, TOOL_MAP, ToolMeta } from '@/lib/tool-catalog';
import { getRecentTools, subscribeUsageChanges, ToolSummary } from '@/lib/usage';

const RECENT_LIMIT = 5;

export default function IndexScreen() {
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';
  const [recentTools, setRecentTools] = React.useState<ToolSummary[]>([]);

  const loadRecentTools = React.useCallback(async () => {
    const tools = await getRecentTools(RECENT_LIMIT);
    setRecentTools(tools);
  }, []);

  useFocusEffect(
    React.useCallback(() => {
      loadRecentTools();
    }, [loadRecentTools])
  );

  React.useEffect(() => {
    const unsubscribe = subscribeUsageChanges(loadRecentTools);
    return unsubscribe;
  }, [loadRecentTools]);

  const toolGroups = React.useMemo(() => {
    return Object.values(TOOL_CATEGORIES).map((category) => ({
      category,
      tools: TOOL_CATALOG.filter((tool) => tool.category === category.id).sort((a, b) => a.order - b.order),
    }));
  }, []);

  const topTool = recentTools[0] ?? TOOL_MAP.eclock;

  return (
    <ScrollView
      className="flex-1 bg-background"
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ paddingBottom: 100 }}
    >
      <View className="px-5 pt-16 pb-3">
        <Text className="text-[32px] font-bold text-foreground tracking-tight leading-10">工具箱</Text>
      </View>

      <View className="px-5 gap-6">
        <View>
          <View className="flex-row items-center justify-between mb-3">
            <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">最近使用</Text>
            <Text className="text-[13px] font-medium text-primary">按使用记录排序</Text>
          </View>

          <ScrollView horizontal showsHorizontalScrollIndicator={false} className="-mx-1">
            <View className="flex-row gap-3 px-1">
              {recentTools.map((tool) => (
                <RecentToolCard key={tool.id} tool={tool} />
              ))}
            </View>
          </ScrollView>
        </View>

        <Link href={topTool.pageUrl as any} asChild>
          <Pressable
            className="active:opacity-80"
            style={{
              borderRadius: 14,
              padding: 16,
              backgroundColor: isDark ? 'rgba(19, 127, 236, 0.14)' : 'rgba(19, 127, 236, 0.08)',
              borderWidth: 1,
              borderColor: isDark ? 'rgba(19, 127, 236, 0.25)' : 'rgba(19, 127, 236, 0.16)',
            }}
          >
            <View className="flex-row items-center gap-3">
              <View className="w-10 h-10 rounded-[10px] items-center justify-center" style={{ backgroundColor: topTool.color + '22' }}>
                <Icon as={Sparkles} color={topTool.color} size={20} strokeWidth={2.2} />
              </View>
              <View className="flex-1">
                <Text className="text-[13px] font-semibold text-primary uppercase tracking-wide">继续使用</Text>
                <Text className="text-[15px] font-semibold text-foreground mt-0.5">{topTool.title}</Text>
              </View>
              <Icon as={ChevronRight} className="text-primary" size={16} strokeWidth={2.5} />
            </View>
          </Pressable>
        </Link>

        {toolGroups.map((group) => (
          <View key={group.category.id}>
            <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest mb-3">
              {group.category.title}
            </Text>
            <View
              className="rounded-[12px] overflow-hidden"
              style={{
                backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
                borderWidth: 1,
                borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
              }}
            >
              {group.tools.map((tool, index) => (
                <Link key={tool.id} href={tool.pageUrl as any} asChild>
                  <Pressable className="active:bg-accent/50">
                    <View className="flex-row items-center px-4 min-h-[56px]">
                      <View className="w-9 h-9 rounded-[8px] items-center justify-center mr-3" style={{ backgroundColor: tool.color + '18' }}>
                        <Icon as={tool.icon} color={tool.color} size={18} strokeWidth={2.2} />
                      </View>
                      <View
                        className="flex-1 flex-row items-center justify-between py-3"
                        style={
                          index !== group.tools.length - 1
                            ? {
                                borderBottomWidth: StyleSheet.hairlineWidth,
                                borderBottomColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)',
                              }
                            : {}
                        }
                      >
                        <View className="flex-1 gap-0.5">
                          <Text className="text-[15px] font-semibold text-foreground">{tool.title}</Text>
                          <Text className="text-[12px] text-muted-foreground">{tool.description}</Text>
                        </View>
                        <Icon as={ChevronRight} className="text-muted-foreground/30 ml-2" size={16} strokeWidth={2.5} />
                      </View>
                    </View>
                  </Pressable>
                </Link>
              ))}
            </View>
          </View>
        ))}
      </View>
    </ScrollView>
  );
}

function RecentToolCard({ tool }: { tool: ToolMeta }) {
  return (
    <Link href={tool.pageUrl as any} asChild>
      <Pressable className="active:opacity-80" style={{ width: 140 }}>
        <View
          className="rounded-[12px] p-4 h-[140px] justify-between"
          style={{
            backgroundColor: tool.gradient[0],
            shadowColor: tool.gradient[0],
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: 0.3,
            shadowRadius: 8,
            elevation: 6,
          }}
        >
          <View className="w-10 h-10 rounded-[10px] items-center justify-center" style={{ backgroundColor: 'rgba(255,255,255,0.2)' }}>
            <Icon as={tool.icon} className="text-white" size={22} strokeWidth={2} />
          </View>
          <View>
            <Text className="text-white font-bold text-[15px]">{tool.title}</Text>
            <Text className="text-white/70 text-[12px] mt-0.5">{tool.description}</Text>
          </View>
        </View>
      </Pressable>
    </Link>
  );
}
