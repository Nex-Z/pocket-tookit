import * as React from 'react';
import { ScrollView, View, Pressable, StyleSheet } from 'react-native';
import { Link } from 'expo-router';
import { Search, ChevronRight } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { Input } from '@/components/ui/input';
import { TOOL_CATALOG, TOOL_CATEGORIES } from '@/lib/tool-catalog';

export default function ExploreScreen() {
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';
  const [searchQuery, setSearchQuery] = React.useState('');

  const normalizedQuery = searchQuery.trim().toLowerCase();

  const categoryGroups = React.useMemo(() => {
    return Object.values(TOOL_CATEGORIES)
      .map((category) => ({
        category,
        tools: TOOL_CATALOG.filter((tool) => tool.category === category.id)
          .filter((tool) => {
            if (!normalizedQuery) return true;
            return (
              tool.title.toLowerCase().includes(normalizedQuery) ||
              tool.description.toLowerCase().includes(normalizedQuery)
            );
          })
          .sort((a, b) => a.order - b.order),
      }))
      .filter((group) => group.tools.length > 0);
  }, [normalizedQuery]);

  return (
    <ScrollView
      className="flex-1 bg-background"
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ paddingBottom: 100 }}
    >
      <View className="px-5 pt-16 pb-1">
        <Text className="text-[32px] font-bold text-foreground tracking-tight leading-10">工具箱</Text>
      </View>

      <View className="px-5 mt-3 mb-2">
        <View
          className="flex-row items-center rounded-[10px] px-3.5 h-[40px]"
          style={{
            backgroundColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.04)',
          }}
        >
          <Icon as={Search} className="text-muted-foreground mr-2" size={18} strokeWidth={2} />
          <Input
            placeholder="搜索可用工具..."
            value={searchQuery}
            onChangeText={setSearchQuery}
            className="flex-1 border-0 bg-transparent h-auto p-0 text-[15px]"
          />
        </View>
      </View>

      <View className="px-5 gap-6 mt-2">
        {categoryGroups.length === 0 ? (
          <View
            className="rounded-[12px] p-5"
            style={{
              backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
              borderWidth: 1,
              borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
            }}
          >
            <Text className="text-[15px] font-semibold text-foreground">未找到匹配工具</Text>
            <Text className="text-[13px] text-muted-foreground mt-1">请尝试其它关键字。</Text>
          </View>
        ) : (
          categoryGroups.map((group) => (
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
                        <View
                          className="w-9 h-9 rounded-[8px] items-center justify-center mr-3"
                          style={{ backgroundColor: tool.color + '18' }}
                        >
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
          ))
        )}
      </View>
    </ScrollView>
  );
}
