import { ScrollView, View } from 'react-native';
import { useEffect, useState } from 'react';
import { useNavigation } from 'expo-router';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Text } from '@/components/ui/text';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';


export default function DmpScreen() {
  const navigation = useNavigation();
  const [token, setToken] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [result, setResult] = useState('');
  const [history, setHistory] = useState([]);

  useEffect(() => {
    navigation.setOptions({
      title: 'DMP打卡',
    });
  }, [navigation]);

  // Mock API call function for DMP clock in/out
  const fetchDmpClock = async (token: string, type: 'in' | 'out') => {
    // Simulate API delay
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    // Simulate success/failure
    const isSuccess = Math.random() > 0.2; // 80% success rate
    
    if (isSuccess) {
      return { 
        success: true, 
        data: { 
          message: `${type === 'in' ? '上班' : '下班'}打卡成功`, 
          timestamp: new Date().toISOString() 
        } 
      };
    } else {
      return { success: false, error: '打卡失败，请重试' };
    }
  };

  const handleClockIn = async (type: 'in' | 'out') => {
    if (!token.trim()) {
      setResult('请输入有效的token');
      return;
    }

    setIsLoading(true);
    setResult('');

    const { success, data, error } = await fetchDmpClock(token, type);

    if (success) {
      const newResult = `${data.message} - ${new Date(data.timestamp).toLocaleString()}`;
      setResult(newResult);
      // 添加到历史记录
      setHistory(prev => [{ time: new Date().toLocaleString(), result: newResult, type }, ...prev.slice(0, 4)]);
    } else {
      const errorMsg = error || '未知错误';
      setResult(errorMsg);
      // 添加到历史记录
      setHistory(prev => [{ time: new Date().toLocaleString(), result: errorMsg, type }, ...prev.slice(0, 4)]);
    }

    setIsLoading(false);
  };

  return (
    <ScrollView className="flex-1 bg-background p-4">
      <Card className="mb-4 border border-border bg-card shadow-sm">
        <CardHeader>
          <CardTitle>DMP打卡</CardTitle>
          <CardDescription>数据管理平台打卡工具</CardDescription>
        </CardHeader>
        <CardContent className="gap-6">
          <View className="gap-4">
            <View>
              <Text className="mb-2 text-foreground">填写token</Text>
              <Input
                placeholder="请输入token"
                value={token}
                onChangeText={setToken}
                className="h-12"
              />
            </View>
            
            <View className="flex-row gap-3">
              <Button
                className="flex-1 h-12"
                disabled={isLoading}
                onPress={() => handleClockIn('in')}
              >
                上班打卡
              </Button>
              <Button
                className="flex-1 h-12"
                variant="outline"
                disabled={isLoading}
                onPress={() => handleClockIn('out')}
              >
                下班打卡
              </Button>
            </View>
            
            <View>
              <Text className="mb-2 text-foreground font-medium">打卡结果</Text>
              <View className="p-3 rounded-md bg-muted min-h-[60px]">
                <Text className="text-sm text-foreground">{result || '暂无结果'}</Text>
              </View>
            </View>
          </View>
        </CardContent>
      </Card>
      
      <Card className="border border-border bg-card shadow-sm">
        <CardHeader>
          <CardTitle>打卡历史</CardTitle>
          <CardDescription>最近的打卡记录</CardDescription>
        </CardHeader>
        <CardContent>
          {history.length > 0 ? (
            history.map((item, index) => (
              <View key={index} className="mb-3 p-3 rounded-md bg-muted">
                <View className="flex-row justify-between mb-1">
                  <Text className="text-xs text-muted-foreground">{item.time}</Text>
                  <Text className="text-xs font-medium" style={{ color: item.type === 'in' ? '#10b981' : '#ef4444' }}>
                    {item.type === 'in' ? '上班' : '下班'}
                  </Text>
                </View>
                <Text className="text-sm text-foreground">{item.result}</Text>
              </View>
            ))
          ) : (
            <Text className="text-muted-foreground text-center py-4">暂无打卡历史</Text>
          )}
        </CardContent>
      </Card>
    </ScrollView>
  );
}