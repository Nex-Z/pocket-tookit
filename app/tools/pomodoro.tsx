import { useEffect, useMemo, useState } from 'react';
import { ScrollView, View, Pressable, TextInput } from 'react-native';
import { useNavigation } from 'expo-router';
import { Play, Pause, RotateCcw, Coffee, Target } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { Button } from '@/components/ui/button';
import { POMODORO_STATE_KEY, recordToolOpen, safeStorageGetItem, safeStorageSetItem } from '@/lib/usage';

type PomodoroPhase = 'focus' | 'break';

type PomodoroPersistedState = {
  focusMinutes: number;
  breakMinutes: number;
  completedCount: number;
};

const DEFAULT_STATE: PomodoroPersistedState = {
  focusMinutes: 25,
  breakMinutes: 5,
  completedCount: 0,
};

function formatDuration(seconds: number) {
  const safeSeconds = Math.max(0, seconds);
  const min = Math.floor(safeSeconds / 60)
    .toString()
    .padStart(2, '0');
  const sec = (safeSeconds % 60).toString().padStart(2, '0');
  return `${min}:${sec}`;
}

function parseMinutes(input: string, fallback: number) {
  const value = Number(input);
  if (!Number.isFinite(value)) return fallback;
  return Math.max(1, Math.min(120, Math.round(value)));
}

export default function PomodoroScreen() {
  const navigation = useNavigation();
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';

  const [focusMinutes, setFocusMinutes] = useState(DEFAULT_STATE.focusMinutes);
  const [breakMinutes, setBreakMinutes] = useState(DEFAULT_STATE.breakMinutes);
  const [completedCount, setCompletedCount] = useState(DEFAULT_STATE.completedCount);
  const [phase, setPhase] = useState<PomodoroPhase>('focus');
  const [isRunning, setIsRunning] = useState(false);
  const [remainingSeconds, setRemainingSeconds] = useState(DEFAULT_STATE.focusMinutes * 60);

  useEffect(() => {
    recordToolOpen('pomodoro').catch(() => {});
  }, []);

  useEffect(() => {
    navigation.setOptions({
      title: '番茄钟',
      headerStyle: {
        backgroundColor: isDark ? '#111318' : '#F0F2F5',
      },
      headerTintColor: isDark ? '#EDF1F5' : '#1A202C',
      headerShadowVisible: false,
    });
  }, [navigation, isDark]);

  useEffect(() => {
    let cancelled = false;

    const loadState = async () => {
      const raw = await safeStorageGetItem(POMODORO_STATE_KEY);
      if (!raw || cancelled) return;
      try {
        const parsed = JSON.parse(raw) as Partial<PomodoroPersistedState>;
        const nextFocus = parseMinutes(String(parsed.focusMinutes ?? DEFAULT_STATE.focusMinutes), DEFAULT_STATE.focusMinutes);
        const nextBreak = parseMinutes(String(parsed.breakMinutes ?? DEFAULT_STATE.breakMinutes), DEFAULT_STATE.breakMinutes);
        const nextCompleted = Number.isFinite(Number(parsed.completedCount)) ? Math.max(0, Number(parsed.completedCount)) : 0;

        setFocusMinutes(nextFocus);
        setBreakMinutes(nextBreak);
        setCompletedCount(nextCompleted);
        setRemainingSeconds(nextFocus * 60);
      } catch {
        // ignore invalid cache
      }
    };

    loadState();
    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    const persistState = async () => {
      const state: PomodoroPersistedState = { focusMinutes, breakMinutes, completedCount };
      await safeStorageSetItem(POMODORO_STATE_KEY, JSON.stringify(state));
    };

    persistState().catch(() => {});
  }, [focusMinutes, breakMinutes, completedCount]);

  useEffect(() => {
    if (!isRunning) return;

    const timer = setInterval(() => {
      setRemainingSeconds((prev) => {
        if (prev > 1) return prev - 1;

        if (phase === 'focus') {
          setCompletedCount((count) => count + 1);
          setPhase('break');
          return breakMinutes * 60;
        }

        setPhase('focus');
        return focusMinutes * 60;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [isRunning, phase, focusMinutes, breakMinutes]);

  const phaseLabel = phase === 'focus' ? '专注中' : '休息中';
  const phaseIcon = phase === 'focus' ? Target : Coffee;
  const phaseColor = phase === 'focus' ? '#EF4444' : '#14B8A6';
  const progress = useMemo(() => {
    const total = (phase === 'focus' ? focusMinutes : breakMinutes) * 60;
    if (total <= 0) return 0;
    return 1 - remainingSeconds / total;
  }, [phase, focusMinutes, breakMinutes, remainingSeconds]);

  return (
    <ScrollView className="flex-1 bg-background" showsVerticalScrollIndicator={false} contentContainerStyle={{ padding: 16, paddingBottom: 96 }}>
      <View className="gap-4">
        <View
          className="rounded-[14px] p-5 items-center"
          style={{
            backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
            borderWidth: 1,
            borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
          }}
        >
          <View className="flex-row items-center gap-2 mb-2">
            <Icon as={phaseIcon} color={phaseColor} size={16} strokeWidth={2.3} />
            <Text className="text-[13px] font-semibold" style={{ color: phaseColor }}>
              {phaseLabel}
            </Text>
          </View>
          <Text className="text-[52px] font-bold text-foreground tracking-tight">{formatDuration(remainingSeconds)}</Text>
          <Text className="text-[12px] text-muted-foreground mt-1">已完成 {completedCount} 个专注周期</Text>
          <View className="w-full h-2 rounded-full mt-4 overflow-hidden" style={{ backgroundColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.08)' }}>
            <View className="h-2 rounded-full" style={{ width: `${Math.max(0, Math.min(progress * 100, 100))}%`, backgroundColor: phaseColor }} />
          </View>
        </View>

        <View
          className="rounded-[14px] p-5 gap-4"
          style={{
            backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
            borderWidth: 1,
            borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
          }}
        >
          <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">时长配置（分钟）</Text>

          <View className="flex-row gap-3">
            <View className="flex-1">
              <Text className="text-[13px] text-muted-foreground mb-2">专注时长</Text>
              <TextInput
                keyboardType="numeric"
                value={String(focusMinutes)}
                onChangeText={(value) => {
                  const next = parseMinutes(value, focusMinutes);
                  setFocusMinutes(next);
                  if (!isRunning && phase === 'focus') setRemainingSeconds(next * 60);
                }}
                editable={!isRunning}
                className="h-[44px] rounded-[10px] px-3 text-foreground"
                style={{
                  backgroundColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.03)',
                  borderWidth: 1,
                  borderColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.1)',
                }}
              />
            </View>
            <View className="flex-1">
              <Text className="text-[13px] text-muted-foreground mb-2">休息时长</Text>
              <TextInput
                keyboardType="numeric"
                value={String(breakMinutes)}
                onChangeText={(value) => {
                  const next = parseMinutes(value, breakMinutes);
                  setBreakMinutes(next);
                  if (!isRunning && phase === 'break') setRemainingSeconds(next * 60);
                }}
                editable={!isRunning}
                className="h-[44px] rounded-[10px] px-3 text-foreground"
                style={{
                  backgroundColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.03)',
                  borderWidth: 1,
                  borderColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.1)',
                }}
              />
            </View>
          </View>

          <View className="flex-row gap-3">
            <Button className="flex-1 h-[46px] rounded-[10px] gap-2" onPress={() => setIsRunning((prev) => !prev)} style={{ backgroundColor: '#137fec' }}>
              <Icon as={isRunning ? Pause : Play} className="text-white" size={16} strokeWidth={2.5} />
              <Text className="text-white font-semibold">{isRunning ? '暂停' : '开始'}</Text>
            </Button>
            <Button
              className="flex-1 h-[46px] rounded-[10px] gap-2"
              onPress={() => {
                setIsRunning(false);
                setPhase('focus');
                setRemainingSeconds(focusMinutes * 60);
              }}
              style={{ backgroundColor: '#6B7280' }}
            >
              <Icon as={RotateCcw} className="text-white" size={16} strokeWidth={2.5} />
              <Text className="text-white font-semibold">重置</Text>
            </Button>
          </View>
        </View>
      </View>
    </ScrollView>
  );
}
