---
name: immersive_design_system
description: Pocket Toolkit 项目的沉浸式深色设计系统范式与 UI 极佳实践标准，用于指导子页面及新组件的设计开发。
---

# 🎨 沉浸式设计语言与 UI 规范代码范式 

本规范指导当前基于 **Expo Router + NativeWind (Tailwind) + React Native** 的 `pocket-toolkit` 移动端项目开发。所有的页面、子工具页新增时必须遵循此范式，维持统一的“沉浸式全屏玻璃交互质感”以及“高对比度高饱和度主色调”。

## 一、 视觉底层核心参数

- **背景主色 (Background)**:
  - 深色模式底色: `#111318` (极致深海沉浸感)
  - 浅色模式底色: `#F0F2F5` / `#FFFFFF`
- **品牌主色 (Primary)**: `#137fec` (高明度科技蓝，保证高对比度)
- **字体标准 (Typography)**: 强制采用 `Inter` 无衬线体。
- **圆角 (Border Radius)**: 
  - 小卡片或按钮推荐 `8px` (`rounded-[8px]`)。
  - 主容器卡片强制使用 `12px` ~ `16px` (`rounded-[12px]`)。

---

## 二、 页面骨架通用模版 (Page Layout Paradigm)

每个子工具页面应抛弃原本丑陋的 React Navigation 默认导航头背景，改由 `ScrollView` 接管沉浸式体验：

```tsx
import { ScrollView, View } from 'react-native';
import { useColorScheme } from 'nativewind';
import { useNavigation } from 'expo-router';
import { useEffect } from 'react';

export default function NewToolScreen() {
  const navigation = useNavigation();
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';

  useEffect(() => {
    // 强制消除顶部 Header 的阴线与突兀感，融入背景
    navigation.setOptions({
      title: '工具名称',
      headerStyle: {
        backgroundColor: isDark ? '#111318' : '#F0F2F5',
      },
      headerTintColor: isDark ? '#EDF1F5' : '#1A202C',
      headerShadowVisible: false, // 重要的扁平化消除线处理
    });
  }, [navigation, isDark]);

  return (
    <ScrollView 
      className="flex-1 bg-background"
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ padding: 20, paddingBottom: 100 }}
    >
      {/* 1. 顶部视觉横幅 */}
      {/* 2. 主操作台卡片 */}
      {/* 3. 结果或日志列表 */}
    </ScrollView>
  );
}
```

---

## 三、 组件形态细节设计

### 1. 顶部光晕沉浸式 Banner
请使用主色调的大面积高彩度色块来点名页面的主视觉，加入悬浮发光的毛玻璃和光控。

```tsx
<View 
  className="rounded-[16px] overflow-hidden mb-6"
  style={{
    shadowColor: '#137fec', // 统一使用该区域主色的发光阴影
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.2, // 深色下控制在 0.2-0.25 产生发光错觉
    shadowRadius: 16,
    elevation: 8,
  }}
>
  <View className="p-6" style={{ backgroundColor: '#137fec' }}>
    {/* 随机布置几何装饰性透明圆，打破正方形死板感 */}
    <View className="absolute top-[-40px] right-[-20px] w-[130px] h-[130px] rounded-full" style={{ backgroundColor: 'rgba(255,255,255,0.08)' }} />
    <View className="absolute bottom-[-30px] left-[20%] w-[100px] h-[100px] rounded-full" style={{ backgroundColor: 'rgba(255,255,255,0.06)' }} />
    
    <View className="relative z-10 flex-row items-center gap-4">
      <View className="w-14 h-14 rounded-[12px] bg-white/20 items-center justify-center">
        {/* 用半透明方块包裹 Icon */}
        <Icon as={/* Lucide Icon */} className="text-white" size={28} strokeWidth={2} />
      </View>
      <View className="flex-1">
        <Text className="text-white font-bold text-[22px] mb-1">工具命名</Text>
        <Text className="text-white/80 text-[13px] leading-relaxed">
          工具的具体执行秒数。
        </Text>
      </View>
    </View>
  </View>
</View>
```

### 2. 半透明玻璃面操作台 (Operation Panel)
抛弃普通 `Card` 带来的过重阴线，我们采用轻微玻璃发色，依赖 `hsla` / `rgba` 微边框。

```tsx
<View 
  className="rounded-[14px] p-5 gap-5"
  style={{
    backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
    borderWidth: 1,
    borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
  }}
>
   {/* 输入框和执行按钮放在这里 */}
</View>
```

### 3. 表单与交互输入框
绝对避免带默认底框的输入框，而是使用透明底色的输入框配以内嵌图标和较高的交互热区：

```tsx
<View className="relative justify-center">
  <Input
    placeholder="在此输入数据..."
    className="h-[52px] rounded-[10px] pl-11 bg-transparent text-[15px]" 
    style={{
      backgroundColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.02)',
      borderColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.1)',
    }}
  />
  <View className="absolute left-3.5">
    {/* Input内部装饰性Icon */}
    <Icon as={Terminal} className="text-muted-foreground/60" size={18} strokeWidth={2} />
  </View>
</View>
```

### 4. 流水线式结果 / 历史列表 (List Rows)
不要重叠内联卡片，使用带 `hairlineWidth` 细线的行 `Row` 并排结构：

```tsx
<View 
  className="flex-row items-center px-5 py-4"
  style={index !== list.length - 1 ? { 
    borderBottomWidth: StyleSheet.hairlineWidth, 
    borderBottomColor: isDark ? 'rgba(255,255,255,0.06)' : 'rgba(0,0,0,0.06)' 
  } : {}}
>
  <View 
    className="w-10 h-10 rounded-full items-center justify-center mr-4"
    style={{ backgroundColor: isSuccess ? 'rgba(16, 185, 129, 0.15)' : 'rgba(239, 68, 68, 0.15)' }}
  >
    <Icon 
      as={isSuccess ? CheckCircle2 : XCircle} 
      color={isSuccess ? '#10B981' : '#EF4444'} 
      size={20} strokeWidth={2.5} 
    />
  </View>
  {/* 右侧主次信息文案分层 */}
</View>
```

---

## 四、 图标与组件规范强制约束
1. **统一图标库**: 所有图标只允许从 `lucide-react-native` 取用，不采用混用的第三方材质图片。
2. **图标粗细约束**: 小图标一般使用 `strokeWidth={2}`，强调层面的底侧 / 背景浮层图标或者 Check 选择图标使用 `strokeWidth={2.5}`。
3. **安全区域边界 (Safe Area)**: 使用 `ScrollView` `paddingBottom: 100` 或利用 `insets.bottom` 保留底部导航栏区域的透明缓冲间隙。

> 未来在 AI 添加任何页面或对任意 `pageUrl` 写新内容时，请强制回顾并读取此 `SKILL.md` 的内容对其实施全套重构和布局。
