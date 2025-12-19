import { Tabs } from 'expo-router';
import React from 'react';
import { HapticTab } from '@/components/haptic-tab';
import { useColorScheme } from 'nativewind';
import { HomeIcon, Telescope, Wrench } from 'lucide-react-native';
import { Icon } from '@/components/ui/icon';
import { NAV_THEME, THEME } from '@/lib/theme';
import { Platform } from 'react-native';


export default function TabLayout() {
  const { colorScheme } = useColorScheme();
  const theme = THEME[colorScheme ?? 'light'];
  const isDark = colorScheme === 'dark';

  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: NAV_THEME[colorScheme ?? 'light'].colors.primary,
        tabBarInactiveTintColor: isDark ? '#8E8E93' : '#999999',
        headerShown: false,
        tabBarButton: HapticTab,
        tabBarStyle: {
          backgroundColor: isDark ? 'rgba(28, 28, 30, 0.95)' : 'rgba(255, 255, 255, 0.95)',
          borderTopWidth: 0.5,
          borderTopColor: isDark ? '#38383A' : '#E5E5EA', // iOS Separator colors
          paddingBottom: Platform.OS === 'ios' ? 24 : 8,
          paddingTop: 8,
          height: Platform.OS === 'ios' ? 88 : 64,
          elevation: 0, // Remove Android shadow
          shadowOpacity: 0, // Remove iOS shadow
          position: 'absolute', // For blur effect if we had it
          bottom: 0,
          left: 0,
          right: 0,
        },
        tabBarLabelStyle: {
          fontSize: 10,
          fontWeight: '500',
          marginBottom: 0,
        },
      }}>
      <Tabs.Screen
        name="index"
        options={{
          title: '首页',
          tabBarIcon: ({ color, focused }) => (
            <Icon 
              as={HomeIcon} 
              color={color} 
              size={28}
              strokeWidth={focused ? 2.5 : 2}
            />
          ),
        }}
      />
      <Tabs.Screen
        name="tool"
        options={{
          title: '工具',
          tabBarIcon: ({ color, focused }) => (
            <Icon 
              as={Wrench} 
              color={color} 
              size={28}
              strokeWidth={focused ? 2.5 : 2}
            />
          ),
        }}
      />
      <Tabs.Screen
        name="explore"
        options={{
          title: '发现',
          tabBarIcon: ({ color, focused }) => (
            <Icon 
              as={Telescope} 
              color={color} 
              size={28}
              strokeWidth={focused ? 2.5 : 2}
            />
          ),
        }}
      />
    </Tabs>
  );
}
