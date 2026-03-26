import * as React from 'react';
import { ScrollView, View, Pressable, StyleSheet, Switch, Alert } from 'react-native';
import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { 
  Moon, 
  Sun, 
  Monitor,
  ChevronRight, 
  MessageSquare, 
  ClipboardList,
  Trash2, 
  Info, 
  BarChart3,
  User,
  ExternalLink,
  Star,
  Heart,
  Shield,
} from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

// Usage stats mock data
const usageStats = {
  weeklyCount: 23,
  totalTools: 6,
  favoriteTools: 3,
  topTool: '鹅打卡',
};

type SettingItem = {
  id: string;
  title: string;
  subtitle?: string;
  icon: any;
  color: string;
  type: 'link' | 'toggle' | 'action' | 'info';
  value?: string;
};

type SettingSection = {
  id: string;
  title?: string;
  items: SettingItem[];
};

const settingSections: SettingSection[] = [
  {
    id: 'stats',
    title: '使用概览',
    items: [
      { id: 'stats', title: '使用统计', subtitle: '本周使用 23 次', icon: BarChart3, color: '#137fec', type: 'link' },
    ],
  },
  {
    id: 'feedback',
    title: '交流反馈',
    items: [
      { id: 'feedback', title: '意见反馈', subtitle: '帮助我们改进', icon: MessageSquare, color: '#10B981', type: 'link' },
      { id: 'survey', title: '问卷调查', subtitle: '参与产品调研', icon: ClipboardList, color: '#8B5CF6', type: 'link' },
      { id: 'rate', title: '给个好评', subtitle: '你的支持是我们的动力', icon: Star, color: '#F59E0B', type: 'link' },
    ],
  },
  {
    id: 'data',
    title: '数据管理',
    items: [
      { id: 'cache', title: '清除缓存', subtitle: '12.3 MB', icon: Trash2, color: '#EF4444', type: 'action' },
      { id: 'privacy', title: '隐私政策', icon: Shield, color: '#6366F1', type: 'link' },
    ],
  },
  {
    id: 'about',
    items: [
      { id: 'about', title: '关于', value: 'v2.0.0', icon: Info, color: '#9CA3AF', type: 'info' },
    ],
  },
];

type ThemeOption = 'light' | 'dark' | 'system';

export default function ProfileScreen() {
  const { colorScheme, setColorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';
  const [activeTheme, setActiveTheme] = React.useState<ThemeOption>('dark');

  const handleThemeChange = (theme: ThemeOption) => {
    setActiveTheme(theme);
    if (theme === 'system') {
      // follow system
      setColorScheme('system');
    } else {
      setColorScheme(theme);
    }
  };

  const handleClearCache = () => {
    Alert.alert('清除缓存', '确定要清除所有缓存数据吗？', [
      { text: '取消', style: 'cancel' },
      { text: '确定', style: 'destructive', onPress: () => {} },
    ]);
  };

  const themeOptions: { key: ThemeOption; label: string; icon: any }[] = [
    { key: 'light', label: '浅色', icon: Sun },
    { key: 'dark', label: '深色', icon: Moon },
    { key: 'system', label: '自动', icon: Monitor },
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
        <View 
          className="w-8 h-8 rounded-[7px] items-center justify-center mr-3"
          style={{ backgroundColor: item.color + '18' }}
        >
          <Icon as={item.icon} color={item.color} size={16} strokeWidth={2.2} />
        </View>
        
        <View 
          className="flex-1 flex-row items-center justify-between py-3"
          style={index !== list.length - 1 ? { 
            borderBottomWidth: StyleSheet.hairlineWidth, 
            borderBottomColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)' 
          } : {}}
        >
          <View className="flex-1">
            <Text className="text-[15px] font-medium text-foreground">{item.title}</Text>
            {item.subtitle && (
              <Text className="text-[12px] text-muted-foreground mt-0.5">{item.subtitle}</Text>
            )}
          </View>
          
          {item.type === 'info' && item.value ? (
            <Text className="text-[13px] text-muted-foreground font-medium">{item.value}</Text>
          ) : item.type !== 'action' ? (
            <Icon as={ChevronRight} className="text-muted-foreground/30" size={16} strokeWidth={2.5} />
          ) : null}
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
      {/* Header */}
      <View className="px-5 pt-16 pb-1">
        <Text className="text-[32px] font-bold text-foreground tracking-tight leading-10">
          我的
        </Text>
      </View>

      <View className="px-5 gap-5 mt-4">
        {/* Profile Card */}
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
            <Text className="text-[13px] text-muted-foreground mt-1">本周使用了 {usageStats.weeklyCount} 次工具</Text>
          </View>
          <Icon as={ChevronRight} className="text-muted-foreground/30" size={18} strokeWidth={2.5} />
        </View>

        {/* Theme Selector */}
        <View>
          <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest mb-3">
            外观模式
          </Text>
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
                <Pressable
                  key={option.key}
                  className="flex-1 active:opacity-80"
                  onPress={() => handleThemeChange(option.key)}
                >
                  <View 
                    className="rounded-[10px] py-3 items-center gap-1.5"
                    style={isActive ? {
                      backgroundColor: isDark ? 'rgba(19, 127, 236, 0.15)' : 'rgba(19, 127, 236, 0.08)',
                      borderWidth: 1,
                      borderColor: isDark ? 'rgba(19, 127, 236, 0.3)' : 'rgba(19, 127, 236, 0.2)',
                    } : {}}
                  >
                    <Icon 
                      as={option.icon} 
                      color={isActive ? '#137fec' : (isDark ? '#6B7280' : '#9CA3AF')} 
                      size={20} 
                      strokeWidth={2} 
                    />
                    <Text 
                      className={`text-[12px] font-semibold ${isActive ? 'text-primary' : 'text-muted-foreground'}`}
                    >
                      {option.label}
                    </Text>
                  </View>
                </Pressable>
              );
            })}
          </View>
        </View>

        {/* Quick Stats Row */}
        <View className="flex-row gap-3">
          {[
            { label: '常用工具', value: usageStats.totalTools.toString(), color: '#137fec' },
            { label: '收藏数', value: usageStats.favoriteTools.toString(), color: '#F59E0B' },
            { label: '最爱', value: usageStats.topTool, color: '#10B981' },
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
              <Text className="text-[20px] font-bold text-foreground">{stat.value}</Text>
              <Text className="text-[11px] text-muted-foreground font-medium mt-1">{stat.label}</Text>
            </View>
          ))}
        </View>

        {/* Setting Sections */}
        {settingSections.map((section) => (
          <View key={section.id}>
            {section.title && (
              <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest mb-3">
                {section.title}
              </Text>
            )}
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

        {/* Footer */}
        <View className="items-center py-4">
          <Text className="text-[12px] text-muted-foreground/50 font-medium">
            口袋工具箱 v2.0.0
          </Text>
          <Text className="text-[11px] text-muted-foreground/30 mt-1">
            Made with ❤️
          </Text>
        </View>
      </View>
    </ScrollView>
  );
}
