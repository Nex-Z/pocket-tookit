import { ScrollView, View, StyleSheet, ActivityIndicator } from 'react-native';
import { useEffect, useState } from 'react';
import { useNavigation } from 'expo-router';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { Database, LogIn, LogOut, KeyRound, CheckCircle2, XCircle } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';
import { recordToolOpen } from '@/lib/usage';

export default function DmpScreen() {
  const navigation = useNavigation();
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';

  const [token, setToken] = useState('');
  const [loadingType, setLoadingType] = useState<'in' | 'out' | null>(null);
  const [result, setResult] = useState('');
  const [history, setHistory] = useState<{time: string, result: string, success: boolean, type: 'in'|'out'}[]>([]);

  useEffect(() => {
    recordToolOpen('dmp').catch(() => {});
  }, []);

  useEffect(() => {
    navigation.setOptions({
      title: 'DMP打卡',
      headerStyle: {
        backgroundColor: isDark ? '#111318' : '#F0F2F5',
      },
      headerTintColor: isDark ? '#EDF1F5' : '#1A202C',
      headerShadowVisible: false,
    });
  }, [navigation, isDark]);

  type ClockSuccessResult = {
    success: true;
    data: { message: string; timestamp: string };
  };

  type ClockFailedResult = {
    success: false;
    error: string;
  };

  const fetchDmpClock = async (token: string, type: 'in' | 'out'): Promise<ClockSuccessResult | ClockFailedResult> => {
    await new Promise(resolve => setTimeout(resolve, 800));
    const isSuccess = Math.random() > 0.2;
    if (isSuccess) {
      return { 
        success: true, 
        data: { message: `${type === 'in' ? '上班' : '下班'}打卡成功`, timestamp: new Date().toISOString() } 
      };
    } else {
      return { success: false, error: '打卡服务响应超时，请重试' };
    }
  };

  const handleClockAction = async (type: 'in' | 'out') => {
    if (!token.trim()) {
      setResult('请输入有效的 Token');
      return;
    }

    setLoadingType(type);
    setResult('');

    const result = await fetchDmpClock(token, type);

    if (result.success) {
      const newResult = `${result.data.message}\n时间: ${new Date(result.data.timestamp).toLocaleTimeString()}`;
      setResult(newResult);
      setHistory(prev => [{ time: new Date().toLocaleTimeString(), result: '打卡成功', success: true, type }, ...prev.slice(0, 4)]);
    } else {
      const errorMsg = result.error || '未知错误';
      setResult(errorMsg);
      setHistory(prev => [{ time: new Date().toLocaleTimeString(), result: errorMsg, success: false, type }, ...prev.slice(0, 4)]);
    }

    setLoadingType(null);
  };

  return (
    <ScrollView 
      className="flex-1 bg-background"
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ padding: 16, paddingBottom: 96 }}
    >
      <View className="gap-5">
        <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest pl-1">
          打卡管控
        </Text>
        
        {/* 操作面板 */}
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
              身份秘钥
            </Text>
            <View className="relative justify-center">
              <Input
                placeholder="请输入接口 Token..."
                value={token}
                onChangeText={setToken}
                className="h-[52px] rounded-[10px] pl-11 bg-transparent text-[15px]"
                style={{
                  backgroundColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.02)',
                  borderColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.1)',
                }}
              />
              <View className="absolute left-3.5">
                <Icon as={KeyRound} className="text-muted-foreground/60" size={18} strokeWidth={2} />
              </View>
            </View>
          </View>
          
          <View className="flex-row gap-3">
            <Button
              className="flex-1 h-[52px] rounded-[10px] gap-2"
              disabled={loadingType !== null}
              onPress={() => handleClockAction('in')}
              style={{ backgroundColor: '#10B981' }}
            >
              {loadingType === 'in' ? (
                <ActivityIndicator color="white" size="small" />
              ) : (
                <Icon as={LogIn} className="text-white" size={18} strokeWidth={2.5} />
              )}
              <Text className="text-white font-semibold text-[16px]">
                上班打卡
              </Text>
            </Button>

            <Button
              className="flex-1 h-[52px] rounded-[10px] gap-2"
              disabled={loadingType !== null}
              onPress={() => handleClockAction('out')}
              style={{ backgroundColor: '#F59E0B' }}
            >
              {loadingType === 'out' ? (
                <ActivityIndicator color="white" size="small" />
              ) : (
                <Icon as={LogOut} className="text-white" size={18} strokeWidth={2.5} />
              )}
              <Text className="text-white font-semibold text-[16px]">
                下班打卡
              </Text>
            </Button>
          </View>
          
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
          近期动态
        </Text>
        
        {/* 历史记录列表 */}
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
                  <View className="flex-row items-center gap-2">
                    <Text className="text-[15px] font-semibold text-foreground">
                      {item.type === 'in' ? '上班' : '下班'}
                    </Text>
                    <View 
                      className="px-1.5 py-0.5 rounded-[4px]" 
                      style={{ backgroundColor: item.success ? 'rgba(16, 185, 129, 0.2)' : 'rgba(239, 68, 68, 0.2)' }}
                    >
                      <Text className="text-[10px] font-bold" style={{ color: item.success ? '#10B981' : '#EF4444' }}>
                        {item.success ? '成功' : '失败'}
                      </Text>
                    </View>
                  </View>
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
              <Icon as={Database} className="text-muted-foreground/30 mb-3" size={32} strokeWidth={1.5} />
              <Text className="text-muted-foreground font-medium">还没有任何操作</Text>
            </View>
          )}
        </View>
      </View>
    </ScrollView>
  );
}
