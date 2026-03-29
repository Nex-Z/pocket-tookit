import { ScrollView, View, StyleSheet, Pressable, RefreshControl, Platform, Linking } from 'react-native';
import { useEffect, useState, useCallback } from 'react';
import { useNavigation } from 'expo-router';
import { Text } from '@/components/ui/text';
import { Icon } from '@/components/ui/icon';
import { TrendingUp, Flame, RefreshCw, Clock, Search, ExternalLink } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';
import { recordToolOpen } from '@/lib/usage';

interface ParsedHotItem {
  rank: number;
  title: string;
  heat: number;
  heatText: string;
  tag: string;
  url: string;
  isTop: boolean;
  category: string;
}

const TAG_CONFIG: Record<string, { color: string; bgColor: string }> = {
  热: { color: '#FF6B35', bgColor: 'rgba(255, 107, 53, 0.15)' },
  新: { color: '#00B4D8', bgColor: 'rgba(0, 180, 216, 0.15)' },
  沸: { color: '#EF4444', bgColor: 'rgba(239, 68, 68, 0.15)' },
  爆: { color: '#F59E0B', bgColor: 'rgba(245, 158, 11, 0.15)' },
  荐: { color: '#8B5CF6', bgColor: 'rgba(139, 92, 246, 0.15)' },
};

function formatHeat(num: number): string {
  if (num >= 10000) return `${(num / 10000).toFixed(1).replace(/\.0$/, '')}万`;
  return num.toLocaleString();
}

function getRankStyle(rank: number, isDark: boolean) {
  if (rank === 1) return { color: '#EF4444', fontWeight: '800' as const };
  if (rank === 2) return { color: '#F97316', fontWeight: '800' as const };
  if (rank === 3) return { color: '#F59E0B', fontWeight: '800' as const };
  return { color: isDark ? '#6B7280' : '#9CA3AF', fontWeight: '700' as const };
}

function parseHotSearchData(cards: any[]): ParsedHotItem[] {
  const items: ParsedHotItem[] = [];
  if (!Array.isArray(cards)) return items;

  for (const card of cards) {
    const cardGroup = card.card_group;
    if (!Array.isArray(cardGroup)) continue;

    for (const item of cardGroup) {
      if (!item.desc) continue;

      const title = String(item.desc || '').trim();
      if (!title) continue;

      const picValue = typeof item.pic === 'string' ? item.pic : '';
      const promotionValue = typeof item.promotion === 'string' ? item.promotion : '';
      const isTop = picValue.includes('stick') || promotionValue.includes('置顶') || false;
      const descExtr = String(item.desc_extr || '');

      let heat = 0;
      let category = '';

      if (/^\d+$/.test(descExtr)) {
        heat = parseInt(descExtr, 10);
      } else {
        const match = descExtr.match(/^(.+?)\s+(\d+)$/);
        if (match) {
          category = match[1];
          heat = parseInt(match[2], 10);
        }
      }

      let tag = '';
      const iconValue = typeof item.icon === 'string' ? item.icon : '';
      if (iconValue) {
        if (iconValue.includes('hot') || iconValue.includes('_hot')) tag = '热';
        else if (iconValue.includes('new') || iconValue.includes('_new')) tag = '新';
        else if (iconValue.includes('fei') || iconValue.includes('boil')) tag = '沸';
        else if (iconValue.includes('bao') || iconValue.includes('boom')) tag = '爆';
        else if (iconValue.includes('recom')) tag = '荐';
      }

      if (!tag && heat > 800000) tag = '沸';
      else if (!tag && heat > 500000) tag = '热';

      items.push({
        rank: isTop ? 0 : items.filter((x) => !x.isTop).length + 1,
        title,
        heat,
        heatText: heat > 0 ? formatHeat(heat) : '',
        tag,
        url: (typeof item.scheme === 'string' && item.scheme) || `https://s.weibo.com/weibo?q=${encodeURIComponent(title)}`,
        isTop,
        category: category || (typeof item.category === 'string' ? item.category : ''),
      });
    }
  }

  let rankNum = 1;
  for (const item of items) {
    if (!item.isTop) {
      item.rank = rankNum;
      rankNum += 1;
    }
  }
  return items;
}

const WEIBO_HOT_URL =
  'https://m.weibo.cn/api/container/getIndex?containerid=106003type%3D25%26t%3D3%26disable_hot%3D1%26filter_type%3Drealtimehot';
const WEIBO_HOT_WEB_URL = 'https://m.weibo.cn/p/index?containerid=106003type%3D25%26t%3D3%26disable_hot%3D1%26filter_type%3Drealtimehot';
const WEIBO_AJAX_HOT_URL = 'https://weibo.com/ajax/side/hotSearch';

function parseAjaxHotSearchData(data: any): ParsedHotItem[] {
  const realtime = Array.isArray(data?.realtime) ? data.realtime : [];
  const hotgov = data?.hotgov;
  const items: ParsedHotItem[] = [];

  if (hotgov?.word || hotgov?.note) {
    const title = String(hotgov.note || hotgov.word || '').trim();
    if (title) {
      items.push({
        rank: 0,
        title,
        heat: 0,
        heatText: '',
        tag: '',
        url: hotgov.url || `https://s.weibo.com/weibo?q=${encodeURIComponent(hotgov.word_scheme || title)}`,
        isTop: true,
        category: '',
      });
    }
  }

  for (const item of realtime) {
    if (!item || item.is_ad) continue;
    const title = String(item.note || item.word || '').trim();
    if (!title) continue;

    const heat = Number(item.num || 0);
    const rawTag = String(item.label_name || item.icon_desc || '');
    const tag = typeof rawTag === 'string' ? rawTag.trim() : '';

    items.push({
      rank: 0,
      title,
      heat,
      heatText: heat > 0 ? formatHeat(heat) : '',
      tag,
      url: `https://s.weibo.com/weibo?q=${encodeURIComponent(item.word_scheme || item.word || title)}`,
      isTop: false,
      category: String(item.flag_desc || ''),
    });
  }

  let rank = 1;
  return items.map((item) => {
    if (item.isTop) return item;
    const next = { ...item, rank };
    rank += 1;
    return next;
  });
}

async function fetchWeiboHotJson() {
  const headers = {
    'User-Agent':
      'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
    Accept: 'application/json, text/plain, */*',
    Referer: 'https://m.weibo.cn/',
  };

  if (Platform.OS !== 'web') {
    try {
      const response = await fetch(WEIBO_HOT_URL, { headers });
      if (!response.ok) throw new Error(`HTTP_${response.status}`);
      const primaryJson = await response.json();
      if (primaryJson?.ok === 1 && primaryJson?.data?.cards) {
        return { source: 'mweibo' as const, json: primaryJson };
      }
      throw new Error('PRIMARY_FORMAT');
    } catch {
      const fallback = await fetch(WEIBO_AJAX_HOT_URL, {
        headers: {
          Accept: 'application/json, text/plain, */*',
          Referer: 'https://weibo.com/',
          'User-Agent':
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
        },
      });
      if (!fallback.ok) throw new Error(`HTTP_${fallback.status}`);
      const fallbackJson = await fallback.json();
      if (fallbackJson?.ok === 1 && fallbackJson?.data) {
        return { source: 'weibo_ajax' as const, json: fallbackJson };
      }
      throw new Error('FALLBACK_FORMAT');
    }
  }
  throw new Error('WEB_CORS_BLOCKED');
}

function SkeletonItem({ index, isDark }: { index: number; isDark: boolean }) {
  const shimmerBg = isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)';
  const shimmerFg = isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.06)';

  return (
    <View
      className="flex-row items-center px-4 py-3.5"
      style={
        index < 9
          ? {
              borderBottomWidth: StyleSheet.hairlineWidth,
              borderBottomColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
            }
          : {}
      }
    >
      <View className="w-7 h-5 rounded-[4px] mr-3" style={{ backgroundColor: shimmerFg }} />
      <View className="flex-1 gap-1.5">
        <View className="h-4 rounded-[3px]" style={{ backgroundColor: shimmerFg, width: `${55 + Math.random() * 35}%` }} />
        <View className="h-3 rounded-[3px]" style={{ backgroundColor: shimmerBg, width: `${30 + Math.random() * 20}%` }} />
      </View>
    </View>
  );
}

function HotSearchRow({
  item,
  index,
  total,
  isDark,
}: {
  item: ParsedHotItem;
  index: number;
  total: number;
  isDark: boolean;
}) {
  const rankStyle = getRankStyle(item.rank, isDark);
  const tagConfig = TAG_CONFIG[item.tag];

  const handlePress = () => {
    if (!item.url) return;
    Linking.openURL(item.url).catch(() => {});
  };

  return (
    <Pressable
      onPress={handlePress}
      className="active:bg-accent/30"
      style={({ pressed }) => ({
        opacity: pressed ? 0.85 : 1,
      })}
    >
      <View
        className="flex-row items-center px-4 min-h-[56px]"
        style={
          index !== total - 1
            ? {
                borderBottomWidth: StyleSheet.hairlineWidth,
                borderBottomColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
              }
            : {}
        }
      >
        <View className="w-8 items-center mr-2.5">
          {item.isTop ? (
            <View className="px-1.5 py-0.5 rounded-[3px]" style={{ backgroundColor: 'rgba(239, 68, 68, 0.12)' }}>
              <Text style={{ color: '#EF4444', fontSize: 10, fontWeight: '700' }}>置顶</Text>
            </View>
          ) : (
            <Text
              style={{
                fontSize: item.rank <= 3 ? 18 : 16,
                color: rankStyle.color,
                fontWeight: rankStyle.fontWeight,
                fontFamily: Platform.OS === 'ios' ? 'Helvetica Neue' : 'sans-serif',
                fontVariant: ['tabular-nums'],
              }}
            >
              {item.rank}
            </Text>
          )}
        </View>

        <View className="flex-1 py-3 mr-2">
          <View className="flex-row items-center gap-1.5 flex-wrap">
            <Text className="text-[15px] text-foreground leading-snug" style={{ fontWeight: item.rank <= 3 ? '700' : '500' }} numberOfLines={2}>
              {item.title}
            </Text>
            {item.tag && tagConfig ? (
              <View className="px-1.5 py-[1px] rounded-[3px]" style={{ backgroundColor: tagConfig.bgColor }}>
                <Text style={{ color: tagConfig.color, fontSize: 10, fontWeight: '700', lineHeight: 14 }}>{item.tag}</Text>
              </View>
            ) : null}
          </View>

          <View className="flex-row items-center gap-2 mt-1">
            {item.heatText ? (
              <View className="flex-row items-center gap-1">
                <Icon as={TrendingUp} size={11} color={isDark ? '#6B7280' : '#9CA3AF'} strokeWidth={2} />
                <Text style={{ fontSize: 12, color: isDark ? '#6B7280' : '#9CA3AF', fontWeight: '500', fontVariant: ['tabular-nums'] }}>
                  {item.heatText}
                </Text>
              </View>
            ) : null}
            {item.category ? (
              <Text style={{ fontSize: 11, color: isDark ? 'rgba(255,255,255,0.25)' : 'rgba(0,0,0,0.3)', fontWeight: '500' }}>{item.category}</Text>
            ) : null}
          </View>
        </View>

        <Icon as={ExternalLink} size={14} color={isDark ? 'rgba(255,255,255,0.15)' : 'rgba(0,0,0,0.12)'} strokeWidth={2} />
      </View>
    </Pressable>
  );
}

export default function NewsScreen() {
  const [hotItems, setHotItems] = useState<ParsedHotItem[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [lastUpdated, setLastUpdated] = useState('');
  const [error, setError] = useState('');

  const navigation = useNavigation();
  const { colorScheme } = useColorScheme();
  const isDark = colorScheme === 'dark';

  useEffect(() => {
    recordToolOpen('news').catch(() => {});
  }, []);

  useEffect(() => {
    navigation.setOptions({
      title: '每日快讯',
      headerStyle: {
        backgroundColor: isDark ? '#111318' : '#F0F2F5',
      },
      headerTintColor: isDark ? '#EDF1F5' : '#1A202C',
      headerShadowVisible: false,
    });
  }, [navigation, isDark]);

  const fetchHotSearch = useCallback(async (showRefreshing = false) => {
    if (showRefreshing) setIsRefreshing(true);
    else setIsLoading(true);

    setError('');
    try {
      const result = await fetchWeiboHotJson();
      let parsed: ParsedHotItem[] = [];

      if (result.source === 'mweibo' && result.json.ok === 1 && result.json.data?.cards) {
        parsed = parseHotSearchData(result.json.data.cards);
      } else if (result.source === 'weibo_ajax' && result.json.ok === 1 && result.json.data) {
        parsed = parseAjaxHotSearchData(result.json.data);
      }

      if (parsed.length > 0) {
        setHotItems(parsed);
        setLastUpdated(new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }));
      } else {
        throw new Error('EMPTY_DATA');
      }
    } catch (err: any) {
      setHotItems([]);
      setLastUpdated('');
      if (String(err?.message).includes('HTTP_')) {
        setError('微博接口暂不可用，请下拉刷新重试');
      } else if (Platform.OS === 'web') {
        setError('Web 端受跨域限制，无法直连微博接口，请使用 App 查看实时榜单');
      } else {
        setError('网络异常，暂时无法获取热搜');
      }
    } finally {
      setIsLoading(false);
      setIsRefreshing(false);
    }
  }, []);

  useEffect(() => {
    fetchHotSearch();
  }, [fetchHotSearch]);

  const onRefresh = useCallback(() => {
    fetchHotSearch(true);
  }, [fetchHotSearch]);

  return (
    <ScrollView
      className="flex-1 bg-background"
      showsVerticalScrollIndicator={false}
      contentContainerStyle={{ padding: 16, paddingBottom: 96 }}
      refreshControl={<RefreshControl refreshing={isRefreshing} onRefresh={onRefresh} tintColor="#137fec" />}
    >
      <View className="flex-row items-center justify-between mb-3 px-1">
        <Text className="text-[13px] font-semibold text-muted-foreground uppercase tracking-widest">实时热搜榜</Text>
        {lastUpdated ? (
          <View className="flex-row items-center gap-1.5">
            <Icon as={Clock} size={12} color={isDark ? '#6B7280' : '#9CA3AF'} strokeWidth={2} />
            <Text style={{ fontSize: 12, color: isDark ? '#6B7280' : '#9CA3AF', fontWeight: '500' }}>{lastUpdated} 更新</Text>
          </View>
        ) : null}
      </View>

      {error ? (
        <View
          className="rounded-[10px] px-3.5 py-2.5 mb-3 flex-row items-center gap-2"
          style={{
            backgroundColor: 'rgba(245, 158, 11, 0.06)',
            borderWidth: 1,
            borderColor: 'rgba(245, 158, 11, 0.12)',
          }}
        >
          <Icon as={Flame} size={14} color="#F59E0B" strokeWidth={2} />
          <Text style={{ fontSize: 12, color: '#F59E0B', fontWeight: '500', flex: 1 }}>{error}</Text>
          <Pressable onPress={onRefresh} className="active:opacity-60">
            <Icon as={RefreshCw} size={14} color="#F59E0B" strokeWidth={2} />
          </Pressable>
        </View>
      ) : null}

      <View
        className="rounded-[14px] overflow-hidden"
        style={{
          backgroundColor: isDark ? 'hsl(225, 14%, 12%)' : 'hsl(0, 0%, 100%)',
          borderWidth: 1,
          borderColor: isDark ? 'rgba(255,255,255,0.04)' : 'rgba(0,0,0,0.04)',
        }}
      >
        {isLoading ? (
          Array.from({ length: 10 }).map((_, i) => <SkeletonItem key={i} index={i} isDark={isDark} />)
        ) : hotItems.length > 0 ? (
          hotItems.map((item, index) => (
            <HotSearchRow key={`${item.rank}-${item.title}`} item={item} index={index} total={hotItems.length} isDark={isDark} />
          ))
        ) : (
          <View className="py-16 items-center justify-center gap-3">
            <Icon as={Search} className="text-muted-foreground/30" size={36} strokeWidth={1.5} />
            <Text className="text-muted-foreground font-medium text-[15px]">暂无热搜数据</Text>
            {Platform.OS === 'web' ? (
              <Pressable
                onPress={() => Linking.openURL(WEIBO_HOT_WEB_URL).catch(() => {})}
                className="mt-2 px-5 py-2.5 rounded-full active:opacity-70"
                style={{ backgroundColor: isDark ? 'rgba(19, 127, 236, 0.15)' : 'rgba(19, 127, 236, 0.1)' }}
              >
                <Text style={{ color: '#137fec', fontSize: 14, fontWeight: '600' }}>打开微博热搜</Text>
              </Pressable>
            ) : (
              <Pressable
                onPress={onRefresh}
                className="mt-2 px-5 py-2.5 rounded-full active:opacity-70"
                style={{ backgroundColor: isDark ? 'rgba(19, 127, 236, 0.15)' : 'rgba(19, 127, 236, 0.1)' }}
              >
                <Text style={{ color: '#137fec', fontSize: 14, fontWeight: '600' }}>重新加载</Text>
              </Pressable>
            )}
          </View>
        )}
      </View>

      {hotItems.length > 0 && !isLoading ? (
        <View className="items-center mt-4 mb-2">
          <Text style={{ fontSize: 12, color: isDark ? 'rgba(255,255,255,0.2)' : 'rgba(0,0,0,0.2)', fontWeight: '500' }}>
            共 {hotItems.length} 条热搜 · 下拉刷新
          </Text>
        </View>
      ) : null}
    </ScrollView>
  );
}
