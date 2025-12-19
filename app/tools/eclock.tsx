import { ScrollView, View } from 'react-native';
import { useEffect, useState } from 'react';
import { useNavigation } from 'expo-router';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Text } from '@/components/ui/text';


export default function EclockScreen() {
  const [token, setToken] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [result, setResult] = useState('');
  const [history, setHistory] = useState([]);

  const navigation = useNavigation();

  // API call function
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
    } catch (error) {
      console.error('Clock-in API error:', error);
      // Handle network errors (like CORS, connection issues, etc.)
      if (error instanceof TypeError) {
        return { success: false, error: '网络连接错误，请检查服务是否运行' };
      }
      return { success: false, error: error.message };
    }
  };

  useEffect(() => {
    navigation.setOptions({
      title: '鹅打卡',
    });
  }, [navigation]);

  const handleClockIn = async () => {
    if (!token.trim()) {
      setResult('请输入有效的token');
      return;
    }

    setIsLoading(true);
    setResult(''); // Clear previous result

    const { success, data, error } = await fetchClockIn(token);

    if (success) {
      const newResult = `打卡成功: ${JSON.stringify(data)}`;
      setResult(newResult);
      // 添加到历史记录
      setHistory(prev => [{ time: new Date().toLocaleString(), result: newResult }, ...prev.slice(0, 4)]);
    } else {
      const errorMsg = `打卡失败: ${error || '未知错误'}`;
      setResult(errorMsg);
      // 添加到历史记录
      setHistory(prev => [{ time: new Date().toLocaleString(), result: errorMsg }, ...prev.slice(0, 4)]);
    }

    setIsLoading(false);
  };

  return (
    <ScrollView className="flex-1 bg-background p-4">
      <Card className="mb-4 border border-border bg-card shadow-sm">
        <CardHeader>
          <CardTitle>鹅打卡</CardTitle>
          <CardDescription>请输入您的token进行打卡操作</CardDescription>
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
            
            <Button
              className="h-12"
              disabled={isLoading}
              onPress={handleClockIn}
            >
              {isLoading ? '提交中...' : '提交打卡'}
            </Button>
            
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
                <Text className="text-xs text-muted-foreground mb-1">{item.time}</Text>
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