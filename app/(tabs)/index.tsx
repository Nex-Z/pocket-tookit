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
  Briefcase,
  Zap,
  Wrench,
  ChevronRight
} from 'lucide-react-native';
import { cn } from '@/lib/utils';

// Tool category data with icons
const toolCategories = [
  {
    id: 'daily',
    title: '日常工具',
    tools: [
      {
        id: 1,
        title: '鹅打卡',
        description: '记录工作时间',
        pageUrl: '/tools/eclock',
        icon: Clock,
        color: 'text-white',
        bg: 'bg-blue-500',
      },
      {
        id: 2,
        title: 'DMP打卡',
        description: '平台打卡助手',
        pageUrl: '/tools/dmp',
        icon: Database,
        color: 'text-white',
        bg: 'bg-indigo-500',
      },
    ],
  },
  {
    id: 'productivity',
    title: '效率工具',
    tools: [
      {
        id: 3,
        title: '待办事项',
        description: '任务管理',
        pageUrl: '/tools/todo',
        icon: CheckSquare,
        color: 'text-white',
        bg: 'bg-orange-500',
      },
      {
        id: 4,
        title: '计算器',
        description: '多功能计算',
        pageUrl: '/tools/calculator',
        icon: Calculator,
        color: 'text-white',
        bg: 'bg-green-500',
      },
    ],
  },
  {
    id: 'utilities',
    title: '实用工具',
    tools: [
      {
        id: 5,
        title: '单位转换',
        description: '常用单位换算',
        pageUrl: '/tools/converter',
        icon: ArrowRightLeft,
        color: 'text-white',
        bg: 'bg-teal-500',
      },
      {
        id: 6,
        title: '二维码',
        description: '生成与扫描',
        pageUrl: '/tools/qrcode',
        icon: QrCode,
        color: 'text-white',
        bg: 'bg-pink-500',
      },
    ],
  },
];

export default function IndexScreen() {
  return (
    <ScrollView className="flex-1 bg-background" showsVerticalScrollIndicator={false}>
      {/* iOS Large Title */}
      <View className="px-4 pt-14 pb-2">
        <Text className="text-[34px] font-bold text-foreground tracking-tight leading-10">口袋工具箱</Text>
      </View>
      
      <View className="px-4 gap-6 pb-24">
        {toolCategories.map((category) => (
          <View key={category.id}>
            <Text className="px-4 mb-2 text-[13px] font-normal text-muted-foreground uppercase tracking-wide">
              {category.title}
            </Text>
            
            <View className="bg-card rounded-[10px] overflow-hidden">
              {category.tools.map((tool, index) => (
                <Link key={tool.id} href={tool.pageUrl as any} asChild>
                  <Pressable className="active:bg-accent transition-colors">
                    <View className="flex-row items-center pl-4 min-h-[44px]">
                      {/* Icon */}
                      <View className={cn("w-[29px] h-[29px] rounded-[7px] items-center justify-center mr-3", tool.bg)}>
                        <Icon as={tool.icon} className={tool.color} size={18} strokeWidth={2.5} />
                      </View>
                      
                      {/* Content with Separator */}
                      <View 
                        className="flex-1 flex-row items-center justify-between pr-4 py-2.5 border-border"
                        style={index !== category.tools.length - 1 ? { borderBottomWidth: StyleSheet.hairlineWidth } : {}}
                      >
                        <View className="flex-1 justify-center gap-0.5">
                          <Text className="text-[17px] font-normal text-foreground leading-snug">{tool.title}</Text>
                        </View>
                        <View className="flex-row items-center pl-2">
                          <Text className="text-[15px] text-muted-foreground mr-1">{tool.description}</Text>
                          <Icon as={ChevronRight} className="text-muted-foreground/40" size={14} strokeWidth={2.5} />
                        </View>
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
