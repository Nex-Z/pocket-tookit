import { ScrollView, View } from 'react-native';
import { useEffect } from 'react';
import { useNavigation } from 'expo-router';
import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { CheckSquare, ListChecks } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

export default function TodoScreen() {
  const navigation = useNavigation();
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';

  useEffect(() => {
    navigation.setOptions({
      title: '待办事项',
      headerStyle: {
        backgroundColor: isDark ? '#111318' : '#F0F2F5',
      },
      headerTintColor: isDark ? '#EDF1F5' : '#1A202C',
      headerShadowVisible: false,
    });
  }, [navigation, isDark]);

  return (
    <ScrollView className="flex-1 bg-background" showsVerticalScrollIndicator={false} contentContainerStyle={{ padding: 20, paddingBottom: 100 }}>
      <View
        className="rounded-[16px] overflow-hidden mb-6"
        style={{
          shadowColor: '#10B981',
          shadowOffset: { width: 0, height: 8 },
          shadowOpacity: 0.22,
          shadowRadius: 16,
          elevation: 8,
        }}
      >
        <View className="p-6" style={{ backgroundColor: '#10B981' }}>
          <View className="absolute top-[-40px] right-[-20px] w-[130px] h-[130px] rounded-full" style={{ backgroundColor: 'rgba(255,255,255,0.08)' }} />
          <View className="absolute bottom-[-30px] left-[20%] w-[100px] h-[100px] rounded-full" style={{ backgroundColor: 'rgba(255,255,255,0.06)' }} />
          <View className="relative z-10 flex-row items-center gap-4">
            <View className="w-14 h-14 rounded-[12px] bg-white/20 items-center justify-center">
              <Icon as={CheckSquare} className="text-white" size={28} strokeWidth={2} />
            </View>
            <View className="flex-1">
              <Text className="text-white font-bold text-[22px] mb-1">待办事项</Text>
              <Text className="text-white/80 text-[13px] leading-relaxed">任务清单功能正在建设中。</Text>
            </View>
          </View>
        </View>
      </View>

      <View
        className="rounded-[14px] p-5 gap-3"
        style={{
          backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
          borderWidth: 1,
          borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
        }}
      >
        <View className="flex-row items-center gap-2.5">
          <Icon as={ListChecks} color={isDark ? '#9CA3AF' : '#6B7280'} size={18} strokeWidth={2.2} />
          <Text className="text-[15px] font-semibold text-foreground">该页面不再承载每日快讯</Text>
        </View>
        <Text className="text-[14px] text-muted-foreground leading-relaxed">每日快讯已独立到 `/tools/news`，并使用微博实时热搜数据。</Text>
      </View>
    </ScrollView>
  );
}
