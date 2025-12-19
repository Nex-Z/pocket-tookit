import { Link } from 'expo-router';
import * as React from 'react';
import { ScrollView, View, ImageBackground, Pressable, StyleSheet } from 'react-native';
import { Text } from '@/components/ui/text';
import { Button } from '@/components/ui/button';
import { Icon } from '@/components/ui/icon';
import { Sparkles, BookOpen, Users, ChevronRight } from 'lucide-react-native';
import { cn } from '@/lib/utils';

export default function ExploreScreen() {
  return (
    <ScrollView className="flex-1 bg-background" showsVerticalScrollIndicator={false}>
      <View className="px-4 pt-14 pb-2">
        <Text className="text-[34px] font-bold text-foreground tracking-tight leading-10">发现</Text>
      </View>
      
      <View className="px-4 gap-6 pb-24">
        {/* App Store Style Today Card */}
        <View className="bg-card rounded-[14px] overflow-hidden shadow-sm" style={{ shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.08, shadowRadius: 12, elevation: 3 }}>
          <View className="h-[420px] bg-blue-500 relative">
            {/* Abstract Art */}
            <View className="absolute inset-0 bg-blue-600">
               <View className="absolute top-[-50px] right-[-50px] w-64 h-64 bg-blue-400 rounded-full opacity-40 blur-3xl" />
               <View className="absolute bottom-[-20px] left-[-20px] w-56 h-56 bg-indigo-500 rounded-full opacity-40 blur-3xl" />
            </View>
            
            <View className="p-5 h-full justify-between relative z-10">
              <View>
                <Text className="text-blue-100 font-semibold text-[13px] uppercase tracking-wide mb-1">新鲜事</Text>
                <Text className="text-white text-[28px] font-bold leading-tight w-[80%]">
                  口袋工具箱 2.0 
                  {'\n'}全新发布
                </Text>
              </View>
              
              <View>
                <Text className="text-blue-50 text-[15px] leading-relaxed font-medium mb-4 opacity-90">
                  更流畅的交互体验，深色模式完美适配，还有更多实用小工具等你探索。
                </Text>
              </View>
            </View>
          </View>
          
          <View className="p-4 flex-row items-center justify-between bg-card">
            <View className="flex-row items-center gap-3">
               <View className="w-10 h-10 bg-blue-100 dark:bg-blue-900 rounded-[10px] items-center justify-center">
                  <Icon as={Sparkles} className="text-blue-600 dark:text-blue-400" size={20} />
               </View>
               <View>
                  <Text className="text-[15px] font-semibold text-foreground">新功能概览</Text>
                  <Text className="text-[13px] text-muted-foreground">了解本次更新详情</Text>
               </View>
            </View>
            <Button variant="secondary" className="rounded-full px-5 h-8 bg-secondary">
               <Text className="text-primary font-bold text-[13px] uppercase">查看</Text>
            </Button>
          </View>
        </View>

        <View>
          <View className="flex-row items-center justify-between px-1 mb-3 mt-2">
            <Text className="text-[22px] font-bold text-foreground tracking-tight">更多内容</Text>
            <Text className="text-primary text-[17px]">查看全部</Text>
          </View>

          {/* List Style Cards */}
          <View className="bg-card rounded-[10px] overflow-hidden">
            <Pressable className="active:bg-accent transition-colors">
              <View className="flex-row items-center pl-4 min-h-[76px]">
                <View className="w-[48px] h-[48px] rounded-[10px] bg-orange-500 items-center justify-center mr-3">
                  <Icon as={BookOpen} className="text-white" size={26} strokeWidth={2} />
                </View>
                <View 
                  className="flex-1 flex-row items-center justify-between h-full border-border py-3 pr-4"
                  style={{ borderBottomWidth: StyleSheet.hairlineWidth }}
                >
                   <View className="flex-1 justify-center gap-0.5">
                    <Text className="text-[17px] font-semibold text-foreground">使用技巧</Text>
                    <Text className="text-[15px] text-muted-foreground leading-snug" numberOfLines={1}>
                      提升效率的 10 个小窍门，让工作更轻松
                    </Text>
                  </View>
                  <Icon as={ChevronRight} className="text-muted-foreground/40 ml-2" size={16} strokeWidth={2.5} />
                </View>
              </View>
            </Pressable>
            
            <Pressable className="active:bg-accent transition-colors">
              <View className="flex-row items-center pl-4 min-h-[76px]">
                <View className="w-[48px] h-[48px] rounded-[10px] bg-purple-500 items-center justify-center mr-3">
                  <Icon as={Users} className="text-white" size={26} strokeWidth={2} />
                </View>
                <View className="flex-1 flex-row items-center justify-between h-full py-3 pr-4">
                   <View className="flex-1 justify-center gap-0.5">
                    <Text className="text-[17px] font-semibold text-foreground">社区互动</Text>
                    <Text className="text-[15px] text-muted-foreground leading-snug" numberOfLines={1}>
                      加入我们的开发者社区，分享你的创意
                    </Text>
                  </View>
                  <Icon as={ChevronRight} className="text-muted-foreground/40 ml-2" size={16} strokeWidth={2.5} />
                </View>
              </View>
            </Pressable>
          </View>
        </View>
      </View>
    </ScrollView>
  );
}
