import { useEffect, useMemo, useState } from 'react';
import { ScrollView, View, Pressable, TextInput } from 'react-native';
import { useNavigation } from 'expo-router';
import { ArrowRightLeft, Ruler, Weight, Thermometer } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { recordToolOpen } from '@/lib/usage';

type ConverterCategory = 'length' | 'weight' | 'temperature';
type UnitOption = {
  key: string;
  label: string;
};

const UNIT_OPTIONS: Record<ConverterCategory, UnitOption[]> = {
  length: [
    { key: 'm', label: '米 (m)' },
    { key: 'km', label: '千米 (km)' },
    { key: 'cm', label: '厘米 (cm)' },
    { key: 'inch', label: '英寸 (in)' },
    { key: 'ft', label: '英尺 (ft)' },
  ],
  weight: [
    { key: 'kg', label: '千克 (kg)' },
    { key: 'g', label: '克 (g)' },
    { key: 'lb', label: '磅 (lb)' },
    { key: 'oz', label: '盎司 (oz)' },
  ],
  temperature: [
    { key: 'c', label: '摄氏度 (°C)' },
    { key: 'f', label: '华氏度 (°F)' },
    { key: 'k', label: '开尔文 (K)' },
  ],
};

const CATEGORY_META = {
  length: { title: '长度', icon: Ruler, color: '#137fec' },
  weight: { title: '重量', icon: Weight, color: '#8B5CF6' },
  temperature: { title: '温度', icon: Thermometer, color: '#F97316' },
} as const;

const LENGTH_TO_METER: Record<string, number> = {
  m: 1,
  km: 1000,
  cm: 0.01,
  inch: 0.0254,
  ft: 0.3048,
};

const WEIGHT_TO_KG: Record<string, number> = {
  kg: 1,
  g: 0.001,
  lb: 0.45359237,
  oz: 0.028349523125,
};

function convertValue(category: ConverterCategory, value: number, fromUnit: string, toUnit: string) {
  if (category === 'length') {
    const meter = value * LENGTH_TO_METER[fromUnit];
    return meter / LENGTH_TO_METER[toUnit];
  }
  if (category === 'weight') {
    const kg = value * WEIGHT_TO_KG[fromUnit];
    return kg / WEIGHT_TO_KG[toUnit];
  }

  const toCelsius = (input: number, unit: string) => {
    if (unit === 'c') return input;
    if (unit === 'f') return ((input - 32) * 5) / 9;
    return input - 273.15;
  };

  const fromCelsius = (input: number, unit: string) => {
    if (unit === 'c') return input;
    if (unit === 'f') return (input * 9) / 5 + 32;
    return input + 273.15;
  };

  return fromCelsius(toCelsius(value, fromUnit), toUnit);
}

export default function ConverterScreen() {
  const navigation = useNavigation();
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';

  const [category, setCategory] = useState<ConverterCategory>('length');
  const [fromUnit, setFromUnit] = useState('m');
  const [toUnit, setToUnit] = useState('km');
  const [inputValue, setInputValue] = useState('1');

  useEffect(() => {
    recordToolOpen('converter').catch(() => {});
  }, []);

  useEffect(() => {
    navigation.setOptions({
      title: '单位转换',
      headerStyle: {
        backgroundColor: isDark ? '#111318' : '#F0F2F5',
      },
      headerTintColor: isDark ? '#EDF1F5' : '#1A202C',
      headerShadowVisible: false,
    });
  }, [navigation, isDark]);

  useEffect(() => {
    const nextUnits = UNIT_OPTIONS[category];
    setFromUnit(nextUnits[0].key);
    setToUnit(nextUnits[1].key);
  }, [category]);

  const output = useMemo(() => {
    const numericValue = Number(inputValue);
    if (!Number.isFinite(numericValue)) return '--';
    const converted = convertValue(category, numericValue, fromUnit, toUnit);
    return Number.isFinite(converted) ? converted.toFixed(4).replace(/\.?0+$/, '') : '--';
  }, [category, inputValue, fromUnit, toUnit]);

  return (
    <ScrollView className="flex-1 bg-background" showsVerticalScrollIndicator={false} contentContainerStyle={{ padding: 20, paddingBottom: 100 }}>
      <View
        className="rounded-[16px] p-6 mb-5"
        style={{
          backgroundColor: '#14B8A6',
          shadowColor: '#14B8A6',
          shadowOffset: { width: 0, height: 8 },
          shadowOpacity: 0.22,
          shadowRadius: 16,
          elevation: 8,
        }}
      >
        <View className="flex-row items-center gap-3">
          <View className="w-12 h-12 rounded-[10px] bg-white/20 items-center justify-center">
            <Icon as={ArrowRightLeft} className="text-white" size={24} strokeWidth={2.2} />
          </View>
          <View className="flex-1">
            <Text className="text-white font-bold text-[22px]">单位转换</Text>
            <Text className="text-white/80 text-[13px] mt-1">支持长度、重量、温度即时换算</Text>
          </View>
        </View>
      </View>

      <View className="gap-4">
        <View
          className="rounded-[14px] p-5 gap-4"
          style={{
            backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
            borderWidth: 1,
            borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
          }}
        >
          <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">转换类别</Text>
          <View className="flex-row gap-2">
            {(Object.keys(CATEGORY_META) as ConverterCategory[]).map((key) => {
              const item = CATEGORY_META[key];
              const active = category === key;
              return (
                <Pressable key={key} className="flex-1 active:opacity-80" onPress={() => setCategory(key)}>
                  <View
                    className="rounded-[10px] py-3 items-center gap-1"
                    style={
                      active
                        ? {
                            backgroundColor: item.color + '22',
                            borderWidth: 1,
                            borderColor: item.color + '55',
                          }
                        : {
                            backgroundColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.03)',
                          }
                    }
                  >
                    <Icon as={item.icon} color={active ? item.color : isDark ? '#9CA3AF' : '#6B7280'} size={16} strokeWidth={2.2} />
                    <Text className="text-[12px] font-medium" style={{ color: active ? item.color : isDark ? '#9CA3AF' : '#6B7280' }}>
                      {item.title}
                    </Text>
                  </View>
                </Pressable>
              );
            })}
          </View>

          <View>
            <Text className="text-[13px] text-muted-foreground mb-2">输入数值</Text>
            <TextInput
              keyboardType="decimal-pad"
              value={inputValue}
              onChangeText={setInputValue}
              className="h-[46px] rounded-[10px] px-3 text-foreground"
              style={{
                backgroundColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.03)',
                borderWidth: 1,
                borderColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.1)',
              }}
            />
          </View>

          <UnitSelector title="从" units={UNIT_OPTIONS[category]} value={fromUnit} onChange={setFromUnit} isDark={isDark} />
          <UnitSelector title="到" units={UNIT_OPTIONS[category]} value={toUnit} onChange={setToUnit} isDark={isDark} />
        </View>

        <View
          className="rounded-[14px] p-5"
          style={{
            backgroundColor: isDark ? 'rgba(20, 184, 166, 0.12)' : 'rgba(20, 184, 166, 0.08)',
            borderWidth: 1,
            borderColor: isDark ? 'rgba(20, 184, 166, 0.24)' : 'rgba(20, 184, 166, 0.18)',
          }}
        >
          <Text className="text-[13px] text-[#14B8A6] font-semibold uppercase tracking-wide">转换结果</Text>
          <Text className="text-[30px] font-bold text-foreground mt-2">{output}</Text>
          <Text className="text-[13px] text-muted-foreground mt-1">
            {UNIT_OPTIONS[category].find((unit) => unit.key === fromUnit)?.label} → {UNIT_OPTIONS[category].find((unit) => unit.key === toUnit)?.label}
          </Text>
        </View>
      </View>
    </ScrollView>
  );
}

function UnitSelector({
  title,
  units,
  value,
  onChange,
  isDark,
}: {
  title: string;
  units: UnitOption[];
  value: string;
  onChange: (next: string) => void;
  isDark: boolean;
}) {
  return (
    <View>
      <Text className="text-[13px] text-muted-foreground mb-2">{title}</Text>
      <View className="flex-row flex-wrap gap-2">
        {units.map((unit) => {
          const active = unit.key === value;
          return (
            <Pressable key={unit.key} className="active:opacity-75" onPress={() => onChange(unit.key)}>
              <View
                className="rounded-[999px] px-3 py-2"
                style={
                  active
                    ? { backgroundColor: '#14B8A6' }
                    : {
                        backgroundColor: isDark ? 'rgba(255,255,255,0.05)' : 'rgba(0,0,0,0.04)',
                      }
                }
              >
                <Text className="text-[12px] font-medium" style={{ color: active ? 'white' : isDark ? '#9CA3AF' : '#6B7280' }}>
                  {unit.label}
                </Text>
              </View>
            </Pressable>
          );
        })}
      </View>
    </View>
  );
}
