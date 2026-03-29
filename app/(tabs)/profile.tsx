import * as React from 'react';
import { ScrollView, View, Pressable, StyleSheet, Alert } from 'react-native';
import { useFocusEffect } from '@react-navigation/native';
import { Moon, Sun, Monitor, Trash2, Info, BarChart3, User, ChevronRight, Shield } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { clearAppData, getUsageStats, subscribeUsageChanges, UsageStats } from '@/lib/usage';
import { TOOL_MAP } from '@/lib/tool-catalog';

type ThemeOption = 'light' | 'dark' | 'system';

type SettingItem = {
  id: string;
  title: string;
  subtitle?: string;
  icon: any;
  color: string;
  type: 'action' | 'info';
  value?: string;
};

type SettingSection = {
  id: string;
  title?: string;
  items: SettingItem[];
};

const DEFAULT_STATS: UsageStats = {
  weeklyCount: 0,
  totalToolsUsed: 0,
};

export default function ProfileScreen() {
  const { colorScheme, setColorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';
  const [activeTheme, setActiveTheme] = React.useState<ThemeOption>((colorScheme as ThemeOption) || 'system');
  const [stats, setStats] = React.useState<UsageStats>(DEFAULT_STATS);

  React.useEffect(() => {
    setActiveTheme((colorScheme as ThemeOption) || 'system');
  }, [colorScheme]);

  const loadStats = React.useCallback(async () => {
    const nextStats = await getUsageStats('all');
    setStats(nextStats);
  }, []);

  useFocusEffect(
    React.useCallback(() => {
      loadStats();
    }, [loadStats])
  );

  React.useEffect(() => {
    const unsubscribe = subscribeUsageChanges(loadStats);
    return unsubscribe;
  }, [loadStats]);

  const handleThemeChange = (theme: ThemeOption) => {
    setActiveTheme(theme);
    setColorScheme(theme);
  };

  const handleClearCache = () => {
    Alert.alert('清除缓存', '确定要清除使用记录和本地配置吗？', [
      { text: '取消', style: 'cancel' },
      {
        text: '确定',
        style: 'destructive',
        onPress: async () => {
          await clearAppData();
          await loadStats();
        },
      },
    ]);
  };

  const themeOptions: { key: ThemeOption; label: string; icon: any }[] = [
    { key: 'light', label: '浅色', icon: Sun },
    { key: 'dark', label: '深色', icon: Moon },
    { key: 'system', label: '自动', icon: Monitor },
  ];

  const topToolTitle = stats.topToolId ? TOOL_MAP[stats.topToolId].title : '-';
  const lastOpenedTime = stats.lastOpenedAt ? new Date(stats.lastOpenedAt).toLocaleString('zh-CN') : '暂无记录';

  const settingSections: SettingSection[] = [
    {
      id: 'stats',
      title: '使用概览',
      items: [
        {
          id: 'usage',
          title: '使用统计',
          subtitle: `最近 7 天打开 ${stats.weeklyCount} 次`,
          icon: BarChart3,
          color: '#137fec',
          type: 'info',
        },
      ],
    },
    {
      id: 'data',
      title: '数据管理',
      items: [
        { id: 'cache', title: '清除缓存', subtitle: '清空使用记录与工具本地数据', icon: Trash2, color: '#EF4444', type: 'action' },
        { id: 'privacy', title: '隐私说明', subtitle: '数据仅保存在本机，不上传云端', icon: Shield, color: '#6366F1', type: 'info' },
      ],
    },
    {
      id: 'about',
      items: [{ id: 'about', title: '关于', value: 'v2.0.0', icon: Info, color: '#9CA3AF', type: 'info' }],
    },
  ];

  const renderSettingItem = (item: SettingItem, index: number, list: SettingItem[]) => (
    <Pressable
      key={item.id}
      className="active:bg-accent/50"
      onPress={() => {
        if (item.id === 'cache') handleClearCache();
      }}
    >
      <View className="flex-row items-center px-4 min-h-[52px]">
        <View className="w-8 h-8 rounded-[7px] items-center justify-center mr-3" style={{ backgroundColor: item.color + '18' }}>
          <Icon as={item.icon} color={item.color} size={16} strokeWidth={2.2} />
        </View>

        <View
          className="flex-1 flex-row items-center justify-between py-3"
          style={
            index !== list.length - 1
              ? {
                  borderBottomWidth: StyleSheet.hairlineWidth,
                  borderBottomColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)',
                }
              : {}
          }
        >
          <View className="flex-1">
            <Text className="text-[15px] font-medium text-foreground">{item.title}</Text>
            {item.subtitle ? <Text className="text-[12px] text-muted-foreground mt-0.5">{item.subtitle}</Text> : null}
          </View>

          {item.type === 'info' && item.value ? (
            <Text className="text-[13px] text-muted-foreground font-medium">{item.value}</Text>
          ) : item.type === 'action' ? null : (
            <Icon as={ChevronRight} className="text-muted-foreground/30" size={16} strokeWidth={2.5} />
          )}
        </View>
      </View>
    </Pressable>
  );

  return (
    <ScrollView
      className="flex-1 bg-background"
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ paddingBottom: 100 }}
    >
      <View className="px-5 pt-16 pb-1">
        <Text className="text-[32px] font-bold text-foreground tracking-tight leading-10">我的</Text>
      </View>

      <View className="px-5 gap-5 mt-4">
        <View
          className="rounded-[14px] p-5 flex-row items-center gap-4"
          style={{
            backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
            borderWidth: 1,
            borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
          }}
        >
          <View
            className="w-[56px] h-[56px] rounded-full items-center justify-center"
            style={{
              backgroundColor: '#137fec',
              shadowColor: '#137fec',
              shadowOffset: { width: 0, height: 4 },
              shadowOpacity: 0.3,
              shadowRadius: 8,
              elevation: 6,
            }}
          >
            <Icon as={User} className="text-white" size={28} strokeWidth={1.8} />
          </View>
          <View className="flex-1">
            <Text className="text-[18px] font-bold text-foreground">工具箱用户</Text>
            <Text className="text-[13px] text-muted-foreground mt-1">最近 7 天使用了 {stats.weeklyCount} 次工具</Text>
          </View>
        </View>

        <View>
          <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest mb-3">外观模式</Text>
          <View
            className="rounded-[12px] p-1.5 flex-row"
            style={{
              backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
              borderWidth: 1,
              borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
            }}
          >
            {themeOptions.map((option) => {
              const isActive = activeTheme === option.key;
              return (
                <Pressable key={option.key} className="flex-1 active:opacity-80" onPress={() => handleThemeChange(option.key)}>
                  <View
                    className="rounded-[10px] py-3 items-center gap-1.5"
                    style={
                      isActive
                        ? {
                            backgroundColor: isDark ? 'rgba(19, 127, 236, 0.15)' : 'rgba(19, 127, 236, 0.08)',
                            borderWidth: 1,
                            borderColor: isDark ? 'rgba(19, 127, 236, 0.3)' : 'rgba(19, 127, 236, 0.2)',
                          }
                        : {}
                    }
                  >
                    <Icon as={option.icon} color={isActive ? '#137fec' : isDark ? '#6B7280' : '#9CA3AF'} size={20} strokeWidth={2} />
                    <Text className={`text-[12px] font-semibold ${isActive ? 'text-primary' : 'text-muted-foreground'}`}>{option.label}</Text>
                  </View>
                </Pressable>
              );
            })}
          </View>
        </View>

        <View className="flex-row gap-3">
          {[
            { label: '常用工具数', value: stats.totalToolsUsed.toString(), color: '#137fec' },
            { label: '最常用工具', value: topToolTitle, color: '#F59E0B' },
            { label: '最近访问', value: lastOpenedTime, color: '#10B981' },
          ].map((stat) => (
            <View
              key={stat.label}
              className="flex-1 rounded-[12px] p-3.5 items-center"
              style={{
                backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
                borderWidth: 1,
                borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
              }}
            >
              <Text className="text-[13px] font-bold text-foreground text-center" numberOfLines={2}>
                {stat.value}
              </Text>
              <Text className="text-[11px] text-muted-foreground font-medium mt-1">{stat.label}</Text>
            </View>
          ))}
        </View>

        {settingSections.map((section) => (
          <View key={section.id}>
            {section.title ? (
              <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest mb-3">{section.title}</Text>
            ) : null}
            <View
              className="rounded-[12px] overflow-hidden"
              style={{
                backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
                borderWidth: 1,
                borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
              }}
            >
              {section.items.map((item, index) => renderSettingItem(item, index, section.items))}
            </View>
          </View>
        ))}
      </View>
    </ScrollView>
  );
}
