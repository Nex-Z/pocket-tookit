import * as React from 'react';
import { ScrollView, View, Pressable, StyleSheet, Animated } from 'react-native';
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
  ChevronRight,
  Search,
  Cpu,
  Terminal,
  HardDrive,
  TrendingUp,
  Shield,
  FileText,
  GripVertical,
  Star,
  Plus,
  Pencil,
  X,
} from 'lucide-react-native';
import { useColorScheme } from 'nativewind';
import { Input } from '@/components/ui/input';

// All tools categorized
const allToolCategories = [
  {
    id: 'daily',
    title: '日常工具',
    isFavorite: true,
    tools: [
      { id: 1, title: '鹅打卡', description: '记录工作时间', pageUrl: '/tools/eclock', icon: Clock, color: '#137fec' },
      { id: 2, title: 'DMP打卡', description: '平台打卡助手', pageUrl: '/tools/dmp', icon: Database, color: '#7C3AED' },
      { id: 3, title: '每日快讯', description: '行业动态资讯', pageUrl: '/tools/news', icon: FileText, color: '#F59E0B' },
    ],
  },
  {
    id: 'productivity',
    title: '效率工具',
    isFavorite: true,
    tools: [
      { id: 4, title: '待办事项', description: '任务管理', pageUrl: '/tools/todo', icon: CheckSquare, color: '#10B981' },
      { id: 5, title: '计算器', description: '多功能计算', pageUrl: '/tools/calculator', icon: Calculator, color: '#EC4899' },
      { id: 6, title: '番茄钟', description: '专注时间管理', pageUrl: '/tools/pomodoro', icon: TrendingUp, color: '#EF4444' },
    ],
  },
  {
    id: 'dev',
    title: '开发工具',
    isFavorite: true,
    tools: [
      { id: 7, title: 'API连接器', description: '接口调试工具', pageUrl: '/tools/api', icon: Cpu, color: '#06B6D4' },
      { id: 8, title: '终端访问', description: '远程命令行', pageUrl: '/tools/terminal', icon: Terminal, color: '#8B5CF6' },
      { id: 9, title: '二维码', description: '生成与扫描', pageUrl: '/tools/qrcode', icon: QrCode, color: '#F97316' },
    ],
  },
  {
    id: 'system',
    title: '实用工具',
    isFavorite: false,
    tools: [
      { id: 10, title: '单位转换', description: '常用单位换算', pageUrl: '/tools/converter', icon: ArrowRightLeft, color: '#14B8A6' },
      { id: 11, title: '磁盘清理', description: '存储空间管理', pageUrl: '/tools/disk', icon: HardDrive, color: '#6366F1' },
      { id: 12, title: '安全检测', description: '系统安全扫描', pageUrl: '/tools/security', icon: Shield, color: '#22C55E' },
    ],
  },
];

// Feature banner
const featureBanner = {
  title: '构建你的专属工作流',
  description: '使用强大的工作流编辑器，将多个工具组合成自定义流程。',
  buttonText: '开始构建',
};

export default function ExploreScreen() {
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';
  const [searchQuery, setSearchQuery] = React.useState('');
  const [isEditing, setIsEditing] = React.useState(false);

  const favorites = allToolCategories.filter(c => c.isFavorite);
  const others = allToolCategories.filter(c => !c.isFavorite);

  // Render a tool row
  const renderToolRow = (
    tool: typeof allToolCategories[0]['tools'][0],
    index: number,
    list: typeof allToolCategories[0]['tools'],
  ) => {
    const inner = (
      <Pressable className="active:bg-accent/50">
        <View className="flex-row items-center px-4 min-h-[56px]">
          {/* Drag handle in edit mode */}
          {isEditing && (
            <View className="mr-2">
              <Icon as={GripVertical} className="text-muted-foreground/40" size={18} strokeWidth={2} />
            </View>
          )}

          <View 
            className="w-9 h-9 rounded-[8px] items-center justify-center mr-3"
            style={{ backgroundColor: tool.color + '18' }}
          >
            <Icon as={tool.icon} color={tool.color} size={18} strokeWidth={2.2} />
          </View>
          
          <View 
            className="flex-1 flex-row items-center justify-between py-3"
            style={index !== list.length - 1 ? { 
              borderBottomWidth: StyleSheet.hairlineWidth, 
              borderBottomColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)' 
            } : {}}
          >
            <View className="flex-1 gap-0.5">
              <Text className="text-[15px] font-semibold text-foreground">{tool.title}</Text>
              <Text className="text-[12px] text-muted-foreground">{tool.description}</Text>
            </View>
            <Icon as={ChevronRight} className="text-muted-foreground/30 ml-2" size={16} strokeWidth={2.5} />
          </View>
        </View>
      </Pressable>
    );

    if (isEditing) {
      return <React.Fragment key={tool.id}>{inner}</React.Fragment>;
    }

    return (
      <Link key={tool.id} href={tool.pageUrl as any} asChild>
        {inner}
      </Link>
    );
  };

  // Render a category section
  const renderCategory = (
    category: typeof allToolCategories[0],
    index: number,
    showFavoriteBadge: boolean = false,
  ) => (
    <View key={category.id}>
      <View className="flex-row items-center gap-2 mb-3">
        {showFavoriteBadge && (
          <Icon as={Star} color="#F59E0B" size={13} strokeWidth={2.5} />
        )}
        <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">
          {category.title}
        </Text>
      </View>
      
      <View 
        className="rounded-[12px] overflow-hidden"
        style={{
          backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
          borderWidth: 1,
          borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
        }}
      >
        {category.tools.map((tool, i) => renderToolRow(tool, i, category.tools))}
      </View>
    </View>
  );

  return (
    <ScrollView 
      className="flex-1 bg-background" 
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ paddingBottom: 100 }}
    >
      {/* Header with Edit toggle */}
      <View className="px-5 pt-16 pb-1 flex-row items-end justify-between">
        <Text className="text-[32px] font-bold text-foreground tracking-tight leading-10">
          工具箱
        </Text>
        <Pressable 
          className="active:opacity-70 pb-1"
          onPress={() => setIsEditing(!isEditing)}
        >
          <View className="flex-row items-center gap-1.5">
            <Icon 
              as={isEditing ? X : Pencil} 
              className="text-primary" 
              size={16} 
              strokeWidth={2.2} 
            />
            <Text className="text-primary font-semibold text-[15px]">
              {isEditing ? '完成' : '编辑'}
            </Text>
          </View>
        </Pressable>
      </View>

      {/* Search Bar */}
      <View className="px-5 mt-3 mb-2">
        <View 
          className="flex-row items-center rounded-[10px] px-3.5 h-[40px]"
          style={{
            backgroundColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.04)',
          }}
        >
          <Icon as={Search} className="text-muted-foreground mr-2" size={18} strokeWidth={2} />
          <Input
            placeholder="搜索工具..."
            value={searchQuery}
            onChangeText={setSearchQuery}
            className="flex-1 border-0 bg-transparent h-auto p-0 text-[15px]"
          />
        </View>
      </View>
      
      <View className="px-5 gap-6 mt-2">
        {/* Feature Banner - only show in browse mode */}
        {!isEditing && (
          <View 
            className="rounded-[16px] overflow-hidden"
            style={{
              shadowColor: '#137fec',
              shadowOffset: { width: 0, height: 8 },
              shadowOpacity: 0.25,
              shadowRadius: 16,
              elevation: 8,
            }}
          >
            <View className="p-5 pb-5" style={{ backgroundColor: '#137fec' }}>
              <View className="absolute top-[-30px] right-[-30px] w-[120px] h-[120px] rounded-full" style={{ backgroundColor: 'rgba(255,255,255,0.1)' }} />
              <View className="absolute bottom-[-20px] left-[40%] w-[80px] h-[80px] rounded-full" style={{ backgroundColor: 'rgba(255,255,255,0.08)' }} />
              
              <View className="relative z-10">
                <Text className="text-[11px] font-bold text-white/70 uppercase tracking-[2px] mb-2">
                  你的必备工具
                </Text>
                <Text className="text-[22px] font-bold text-white leading-tight mb-2">
                  {featureBanner.title}
                </Text>
                <Text className="text-[14px] text-white/80 leading-relaxed mb-4">
                  {featureBanner.description}
                </Text>
                <Pressable 
                  className="self-start rounded-full px-5 py-2.5 active:opacity-80"
                  style={{ backgroundColor: 'rgba(255,255,255,0.2)' }}
                >
                  <Text className="text-white font-bold text-[13px]">{featureBanner.buttonText}</Text>
                </Pressable>
              </View>
            </View>
          </View>
        )}

        {/* Edit mode: manage tip */}
        {isEditing && (
          <View 
            className="rounded-[12px] p-4 flex-row items-center gap-3"
            style={{
              backgroundColor: isDark ? 'rgba(19, 127, 236, 0.08)' : 'rgba(19, 127, 236, 0.05)',
              borderWidth: 1,
              borderColor: isDark ? 'rgba(19, 127, 236, 0.15)' : 'rgba(19, 127, 236, 0.1)',
            }}
          >
            <View className="w-9 h-9 rounded-[8px] items-center justify-center" style={{ backgroundColor: '#137fec' }}>
              <Icon as={GripVertical} className="text-white" size={18} strokeWidth={2} />
            </View>
            <View className="flex-1">
              <Text className="text-[14px] font-bold text-foreground">拖动排序</Text>
              <Text className="text-[12px] text-muted-foreground mt-0.5">拖拽工具或分组来重新排列你的工具箱</Text>
            </View>
          </View>
        )}

        {/* Categories - in edit mode, split favorites / others */}
        {isEditing ? (
          <>
            {/* Favorites */}
            {favorites.length > 0 && (
              <>
                {favorites.map((cat, i) => renderCategory(cat, i, true))}
              </>
            )}

            {/* Others */}
            {others.length > 0 && (
              <>
                <View className="flex-row items-center gap-2 mt-1">
                  <View className="flex-1 h-[1px]" style={{ backgroundColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)' }} />
                  <Text className="text-[11px] font-medium text-muted-foreground/60 uppercase tracking-widest">未收藏</Text>
                  <View className="flex-1 h-[1px]" style={{ backgroundColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)' }} />
                </View>
                {others.map((cat, i) => renderCategory(cat, i, false))}
              </>
            )}

            {/* Add New Group */}
            <Pressable className="active:opacity-80">
              <View 
                className="rounded-[12px] p-4 flex-row items-center justify-center gap-2"
                style={{
                  borderWidth: 1.5,
                  borderColor: isDark ? 'rgba(19, 127, 236, 0.3)' : 'rgba(19, 127, 236, 0.2)',
                  borderStyle: 'dashed',
                }}
              >
                <Icon as={Plus} className="text-primary" size={18} strokeWidth={2.5} />
                <Text className="text-primary font-semibold text-[14px]">添加新分组</Text>
              </View>
            </Pressable>
          </>
        ) : (
          /* Browse mode - flat category list */
          allToolCategories.map((cat, i) => renderCategory(cat, i, false))
        )}
      </View>
    </ScrollView>
  );
}
