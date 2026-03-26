import * as React from 'react';
import { View, ScrollView, Pressable, StyleSheet } from 'react-native';
import { Link } from 'expo-router';
import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { 
  Clock, 
  Database, 
  CheckSquare, 
  Calculator, 
  ArrowRightLeft, 
  QrCode,
  Zap,
  ChevronRight,
  Cpu,
  Terminal,
  HardDrive,
  Wifi,
  TrendingUp,
  AlertCircle,
} from 'lucide-react-native';
import { cn } from '@/lib/utils';
import { useColorScheme } from 'nativewind';

// Recent tools data
const recentTools = [
  {
    id: 'eclock',
    title: '鹅打卡',
    label: '效率',
    pageUrl: '/tools/eclock',
    icon: Clock,
    gradient: ['#137fec', '#0A5BBF'],
  },
  {
    id: 'dmp',
    title: 'DMP打卡',
    label: '更新',
    pageUrl: '/tools/dmp',
    icon: Database,
    gradient: ['#7C3AED', '#5B21B6'],
  },
  {
    id: 'todo',
    title: '每日快讯',
    label: '',
    pageUrl: '/tools/todo',
    icon: Zap,
    gradient: ['#F59E0B', '#D97706'],
  },
];

// Categories
const categories = [
  { id: 'daily', title: '日常', icon: Clock, color: '#137fec' },
  { id: 'productivity', title: '效率', icon: TrendingUp, color: '#10B981' },
  { id: 'dev', title: '开发', icon: Terminal, color: '#7C3AED' },
  { id: 'system', title: '系统', icon: Cpu, color: '#F59E0B' },
  { id: 'network', title: '网络', icon: Wifi, color: '#EF4444' },
  { id: 'convert', title: '转换', icon: ArrowRightLeft, color: '#EC4899' },
];

// Favorite tools
const favoriteTools = [
  {
    id: 'api',
    title: 'API连接器',
    status: '已连接',
    statusTime: '2分钟前',
    icon: Cpu,
    statusColor: '#10B981',
  },
  {
    id: 'shell',
    title: '终端访问',
    status: '空闲',
    statusTime: '1小时前',
    icon: Terminal,
    statusColor: '#F59E0B',
  },
  {
    id: 'disk',
    title: '磁盘清理',
    status: '就绪',
    statusTime: '',
    icon: HardDrive,
    statusColor: '#137fec',
  },
];

// System audit notification
const auditNotification = {
  message: '在你的工作流中发现3个可优化项。',
  icon: AlertCircle,
};

export default function IndexScreen() {
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';

  return (
    <ScrollView 
      className="flex-1 bg-background" 
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ paddingBottom: 100 }}
    >
      {/* Header */}
      <View className="px-5 pt-16 pb-3">
        <Text className="text-[32px] font-bold text-foreground tracking-tight leading-10">
          工具箱
        </Text>
      </View>
      
      <View className="px-5 gap-6">
        {/* Recent Tools - Horizontal Scroll */}
        <View>
          <View className="flex-row items-center justify-between mb-3">
            <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">
              最近使用
            </Text>
            <Text className="text-[13px] font-medium text-primary">查看全部</Text>
          </View>
          
          <ScrollView horizontal showsHorizontalScrollIndicator={false} className="-mx-1">
            <View className="flex-row gap-3 px-1">
              {recentTools.map((tool) => (
                <Link key={tool.id} href={tool.pageUrl as any} asChild>
                  <Pressable 
                    className="active:opacity-80"
                    style={{ width: 140 }}
                  >
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
                        {tool.label ? (
                          <Text className="text-white/70 text-[12px] mt-0.5">{tool.label}</Text>
                        ) : null}
                      </View>
                    </View>
                  </Pressable>
                </Link>
              ))}
            </View>
          </ScrollView>
        </View>

        {/* System Audit Banner */}
        <View 
          className="rounded-[12px] p-4 flex-row items-center gap-3"
          style={{
            backgroundColor: isDark ? 'rgba(19, 127, 236, 0.12)' : 'rgba(19, 127, 236, 0.08)',
            borderWidth: 1,
            borderColor: isDark ? 'rgba(19, 127, 236, 0.2)' : 'rgba(19, 127, 236, 0.15)',
          }}
        >
          <View className="w-9 h-9 rounded-full items-center justify-center" style={{ backgroundColor: '#137fec' }}>
            <Icon as={auditNotification.icon} className="text-white" size={18} strokeWidth={2.5} />
          </View>
          <View className="flex-1">
            <Text className="text-[13px] font-bold text-primary uppercase tracking-wide">系统审计</Text>
            <Text className="text-[14px] text-foreground mt-0.5">{auditNotification.message}</Text>
          </View>
          <Icon as={ChevronRight} className="text-primary" size={16} strokeWidth={2.5} />
        </View>

        {/* Categories Grid */}
        <View>
          <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest mb-3">
            分类
          </Text>
          <View className="flex-row flex-wrap gap-3">
            {categories.map((cat) => (
              <Pressable 
                key={cat.id} 
                className="active:opacity-80"
                style={{ width: '30%' }}
              >
                <View 
                  className="rounded-[12px] p-3.5 items-center gap-2.5"
                  style={{
                    backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
                    borderWidth: 1,
                    borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
                  }}
                >
                  <View 
                    className="w-11 h-11 rounded-[10px] items-center justify-center"
                    style={{ backgroundColor: cat.color + '18' }}
                  >
                    <Icon as={cat.icon} color={cat.color} size={22} strokeWidth={2} />
                  </View>
                  <Text className="text-[13px] font-semibold text-foreground">{cat.title}</Text>
                </View>
              </Pressable>
            ))}
          </View>
        </View>

        {/* Favorites */}
        <View>
          <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest mb-3">
            收藏
          </Text>
          <View 
            className="rounded-[12px] overflow-hidden"
            style={{
              backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
              borderWidth: 1,
              borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
            }}
          >
            {favoriteTools.map((tool, index) => (
              <Pressable key={tool.id} className="active:bg-accent/50">
                <View className="flex-row items-center px-4 min-h-[64px]">
                  <View 
                    className="w-10 h-10 rounded-[10px] items-center justify-center mr-3"
                    style={{ backgroundColor: tool.statusColor + '18' }}
                  >
                    <Icon as={tool.icon} color={tool.statusColor} size={20} strokeWidth={2} />
                  </View>
                  
                  <View 
                    className="flex-1 flex-row items-center justify-between py-3"
                    style={index !== favoriteTools.length - 1 ? { 
                      borderBottomWidth: StyleSheet.hairlineWidth, 
                      borderBottomColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)' 
                    } : {}}
                  >
                    <Text className="text-[15px] font-semibold text-foreground">{tool.title}</Text>
                    <View className="flex-row items-center gap-1.5">
                      <View 
                        className="w-2 h-2 rounded-full" 
                        style={{ backgroundColor: tool.statusColor }}
                      />
                      <Text className="text-[12px] text-muted-foreground font-medium">
                        {tool.status}{tool.statusTime ? ` · ${tool.statusTime}` : ''}
                      </Text>
                    </View>
                  </View>
                </View>
              </Pressable>
            ))}
          </View>
        </View>
      </View>
    </ScrollView>
  );
}
