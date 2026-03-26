import { ScrollView, View, StyleSheet, ActivityIndicator } from 'react-native';
import { useEffect, useState } from 'react';
import { useNavigation } from 'expo-router';
import { Card, CardContent } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { Clock, Terminal, CheckCircle2, XCircle, Send } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

export default function EclockScreen() {
  const [token, setToken] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [result, setResult] = useState('');
  const [history, setHistory] = useState<{time: string, result: string, success: boolean}[]>([]);

  const navigation = useNavigation();
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';

  const fetchClockIn = async (token: string) => {
    const apiUrl = 'http://localhost:5001/api/v1/clockIn';
    try {
      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ token }),
      });
      const data = await response.json();
      return { success: response.ok, data };
    } catch (error: any) {
      if (error instanceof TypeError) {
        return { success: false, error: '网络连接错误，请检查服务是否运行' };
      }
      return { success: false, error: error?.message || '未知错误' };
    }
  };

  useEffect(() => {
    navigation.setOptions({
      title: '鹅打卡',
      headerStyle: {
        backgroundColor: isDark ? '#111318' : '#F0F2F5',
      },
      headerTintColor: isDark ? '#EDF1F5' : '#1A202C',
      headerShadowVisible: false,
    });
  }, [navigation, isDark]);

  const handleClockIn = async () => {
    if (!token.trim()) {
      setResult('请输入有效的 Token');
      return;
    }
    setIsLoading(true);
    setResult('');
    
    // 模拟等待效果 (如果本地服务没开，让loading稍微展示一会让UI有反馈)
    await new Promise(resolve => setTimeout(resolve, 600));

    const { success, data, error } = await fetchClockIn(token);

    if (success) {
      const newResult = `打卡成功: ${JSON.stringify(data)}`;
      setResult(newResult);
      setHistory(prev => [{ time: new Date().toLocaleTimeString(), result: '打卡成功', success: true }, ...prev.slice(0, 4)]);
    } else {
      const errorMsg = `${error || '未知错误'}`;
      setResult(errorMsg);
      setHistory(prev => [{ time: new Date().toLocaleTimeString(), result: errorMsg, success: false }, ...prev.slice(0, 4)]);
    }
    setIsLoading(false);
  };

  return (
    <ScrollView 
      className="flex-1 bg-background"
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ padding: 20, paddingBottom: 100 }}
    >
      {/* 顶部横幅 */}
      <View 
        className="rounded-[16px] overflow-hidden mb-6"
        style={{
          shadowColor: '#137fec',
          shadowOffset: { width: 0, height: 8 },
          shadowOpacity: 0.2,
          shadowRadius: 16,
          elevation: 8,
        }}
      >
        <View className="p-6" style={{ backgroundColor: '#137fec' }}>
          <View className="absolute top-[-40px] right-[-20px] w-[130px] h-[130px] rounded-full" style={{ backgroundColor: 'rgba(255,255,255,0.08)' }} />
          <View className="absolute bottom-[-30px] left-[20%] w-[100px] h-[100px] rounded-full" style={{ backgroundColor: 'rgba(255,255,255,0.06)' }} />
          
          <View className="relative z-10 flex-row items-center gap-4">
            <View className="w-14 h-14 rounded-[12px] bg-white/20 items-center justify-center">
              <Icon as={Clock} className="text-white" size={28} strokeWidth={2} />
            </View>
            <View className="flex-1">
              <Text className="text-white font-bold text-[22px] mb-1">鹅打卡</Text>
              <Text className="text-white/80 text-[13px] leading-relaxed">
                输入您的 Token 以进行快速打卡操作，记录您的工作时间。
              </Text>
            </View>
          </View>
        </View>
      </View>

      <View className="gap-5">
        <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest pl-1">
          操作面板
        </Text>
        
        <View 
          className="rounded-[14px] p-5 gap-5"
          style={{
            backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
            borderWidth: 1,
            borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
          }}
        >
          <View>
            <Text className="text-[14px] font-medium text-foreground mb-2.5">
              身份 Token
            </Text>
            <View className="relative justify-center">
              <Input
                placeholder="在此输入 Token..."
                value={token}
                onChangeText={setToken}
                className="h-[52px] rounded-[10px] pl-11 bg-transparent text-[15px]"
                style={{
                  backgroundColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.02)',
                  borderColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.1)',
                }}
              />
              <View className="absolute left-3.5">
                <Icon as={Terminal} className="text-muted-foreground/60" size={18} strokeWidth={2} />
              </View>
            </View>
          </View>
          
          <Button
            className="h-[52px] rounded-[10px] gap-2"
            disabled={isLoading}
            onPress={handleClockIn}
            style={{ backgroundColor: '#137fec' }}
          >
            {isLoading ? (
              <ActivityIndicator color="white" size="small" />
            ) : (
              <Icon as={Send} className="text-white" size={18} strokeWidth={2.5} />
            )}
            <Text className="text-white font-semibold text-[16px]">
              {isLoading ? '提交中...' : '提交打卡'}
            </Text>
          </Button>
          
          {result ? (
            <View className="mt-2">
              <Text className="text-[14px] font-medium text-foreground mb-2">执行结果</Text>
              <View 
                className="p-4 rounded-[10px]" 
                style={{ 
                  backgroundColor: isDark ? 'rgba(255,255,255,0.03)' : 'rgba(0,0,0,0.02)',
                  borderWidth: 1,
                  borderColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.05)',
                }}
              >
                <Text className="text-[14px] text-foreground leading-relaxed">{result}</Text>
              </View>
            </View>
          ) : null}
        </View>

        <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest pl-1 mt-4">
          历史记录
        </Text>
        
        <View 
          className="rounded-[14px] overflow-hidden"
          style={{
            backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
            borderWidth: 1,
            borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
          }}
        >
          {history.length > 0 ? (
            history.map((item, index) => (
              <View 
                key={index} 
                className="flex-row items-center px-5 py-4"
                style={index !== history.length - 1 ? { 
                  borderBottomWidth: StyleSheet.hairlineWidth, 
                  borderBottomColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)' 
                } : {}}
              >
                <View 
                  className="w-10 h-10 rounded-full items-center justify-center mr-4"
                  style={{ backgroundColor: item.success ? 'rgba(16, 185, 129, 0.15)' : 'rgba(239, 68, 68, 0.15)' }}
                >
                  <Icon 
                    as={item.success ? CheckCircle2 : XCircle} 
                    color={item.success ? '#10B981' : '#EF4444'} 
                    size={20} 
                    strokeWidth={2.5} 
                  />
                </View>
                <View className="flex-1 gap-1">
                  <Text className="text-[15px] font-semibold text-foreground">
                    {item.success ? '打卡成功' : '打卡失败'}
                  </Text>
                  <Text className="text-[13px] text-muted-foreground" numberOfLines={1}>
                    {item.result}
                  </Text>
                </View>
                <Text className="text-[12px] font-medium text-muted-foreground ml-2">
                  {item.time}
                </Text>
              </View>
            ))
          ) : (
            <View className="py-10 items-center justify-center">
              <Icon as={Clock} className="text-muted-foreground/30 mb-3" size={32} strokeWidth={1.5} />
              <Text className="text-muted-foreground font-medium">暂无打卡历史</Text>
            </View>
          )}
        </View>
      </View>
    </ScrollView>
  );
}