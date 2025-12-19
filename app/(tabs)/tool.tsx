import * as React from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Input } from '@/components/ui/input';
import { ScrollView, View, Platform, StyleSheet } from 'react-native';
import { Button } from '@/components/ui/button';
import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { cn } from '@/lib/utils';

export default function ToolScreen() {
  const [value, setValue] = React.useState('feedback');

  return (
    <ScrollView className="flex-1 bg-background" showsVerticalScrollIndicator={false}>
      <View className="px-4 pt-14 pb-2">
        <Text className="text-[34px] font-bold text-foreground tracking-tight leading-10">工具</Text>
      </View>
      
      <View className="px-4 pb-24">
        <Tabs value={value} onValueChange={setValue} className="w-full">
          {/* iOS Segmented Control Style */}
          <TabsList className="mb-6 grid w-full grid-cols-2 bg-[#767680]/15 dark:bg-[#767680]/25 h-8 p-[2px] rounded-[9px]">
            <TabsTrigger 
              value="feedback" 
              className="data-[state=active]:bg-card dark:data-[state=active]:bg-[#636366] data-[state=active]:text-foreground dark:data-[state=active]:text-white data-[state=active]:shadow-[0_1px_3px_rgba(0,0,0,0.12)] rounded-[7px] h-full text-[13px] font-medium"
            >
              <Text>意见反馈</Text>
            </TabsTrigger>
            <TabsTrigger 
              value="survey" 
              className="data-[state=active]:bg-card dark:data-[state=active]:bg-[#636366] data-[state=active]:text-foreground dark:data-[state=active]:text-white data-[state=active]:shadow-[0_1px_3px_rgba(0,0,0,0.12)] rounded-[7px] h-full text-[13px] font-medium"
            >
              <Text>问卷调查</Text>
            </TabsTrigger>
          </TabsList>

          <TabsContent value="feedback" className="mt-0">
            <View className="mb-2 px-4">
              <Text className="text-[13px] text-muted-foreground uppercase tracking-wide">您的建议</Text>
            </View>
            <View className="bg-card rounded-[10px] overflow-hidden mb-6">
              <View className="pl-4 pr-0 py-3 min-h-[44px] flex-row items-center active:bg-accent">
                <Text className="w-16 text-[17px] font-normal text-foreground">姓名</Text>
                <View 
                  className="flex-1 border-border h-full flex-row items-center pr-4"
                  style={{ borderBottomWidth: StyleSheet.hairlineWidth }}
                >
                  <Input 
                    placeholder="必填" 
                    className="flex-1 border-0 bg-transparent h-auto p-0 text-[17px] leading-none text-right"
                  />
                </View>
              </View>
              
              <View className="pl-4 pr-0 py-3 flex-row items-start min-h-[140px] active:bg-accent">
                <Text className="w-16 text-[17px] font-normal text-foreground pt-0.5">内容</Text>
                <View className="flex-1 h-full pr-4">
                  <Input 
                    placeholder="请输入您的反馈意见..." 
                    className="flex-1 border-0 bg-transparent h-full p-0 text-[17px] align-top leading-snug"
                    multiline
                    textAlignVertical="top"
                  />
                </View>
              </View>
            </View>
            
            <Text className="px-4 text-[13px] text-muted-foreground leading-normal mb-8 text-center">
              我们会认真阅读每一条反馈，感谢您的支持。
            </Text>

            <Button className="mx-4 rounded-[12px] h-[50px] bg-[#007AFF] active:bg-[#0071E3]">
              <Text className="text-white font-semibold text-[17px]">提交反馈</Text>
            </Button>
          </TabsContent>

          <TabsContent value="survey" className="mt-0">
            <View className="mb-2 px-4">
              <Text className="text-[13px] text-muted-foreground uppercase tracking-wide">用户调查</Text>
            </View>
            <View className="bg-card rounded-[10px] overflow-hidden mb-8">
              <View className="pl-4 pr-0 py-3 min-h-[44px] flex-row items-center active:bg-accent">
                <Text className="w-24 text-[17px] font-normal text-foreground">当前职位</Text>
                <View 
                  className="flex-1 border-border h-full flex-row items-center pr-4"
                  style={{ borderBottomWidth: StyleSheet.hairlineWidth }}
                >
                  <Input 
                    placeholder="选填" 
                    className="flex-1 border-0 bg-transparent h-auto p-0 text-[17px] leading-none text-right"
                  />
                </View>
              </View>
              
              <View className="pl-4 pr-0 py-3 min-h-[44px] flex-row items-center active:bg-accent">
                <Text className="w-24 text-[17px] font-normal text-foreground">喜爱功能</Text>
                <View 
                  className="flex-1 border-border h-full flex-row items-center pr-4"
                  style={{ borderBottomWidth: StyleSheet.hairlineWidth }}
                >
                  <Input 
                    placeholder="例如：打卡" 
                    className="flex-1 border-0 bg-transparent h-auto p-0 text-[17px] leading-none text-right"
                  />
                </View>
              </View>
              
              <View className="pl-4 pr-0 py-3 flex-row items-start min-h-[140px] active:bg-accent">
                <Text className="w-24 text-[17px] font-normal text-foreground pt-0.5">改进建议</Text>
                <View className="flex-1 h-full pr-4">
                  <Input 
                    placeholder="请提出您的宝贵建议..." 
                    className="flex-1 border-0 bg-transparent h-full p-0 text-[17px] align-top leading-snug"
                    multiline
                    textAlignVertical="top"
                  />
                </View>
              </View>
            </View>
            
            <Button className="mx-4 rounded-[12px] h-[50px] bg-[#007AFF] active:bg-[#0071E3]">
              <Text className="text-white font-semibold text-[17px]">提交问卷</Text>
            </Button>
          </TabsContent>
        </Tabs>
      </View>
    </ScrollView>
  );
}
