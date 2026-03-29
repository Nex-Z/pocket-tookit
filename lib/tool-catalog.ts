import {
  ArrowRightLeft,
  Clock,
  Database,
  FileText,
  LucideIcon,
  Timer,
} from 'lucide-react-native';

export const TOOL_IDS = ['eclock', 'dmp', 'news', 'pomodoro', 'converter'] as const;

export type ToolId = (typeof TOOL_IDS)[number];

export type ToolCategoryId = 'daily' | 'productivity';

export type ToolMeta = {
  id: ToolId;
  title: string;
  description: string;
  pageUrl: `/tools/${string}`;
  icon: LucideIcon;
  color: string;
  gradient: [string, string];
  category: ToolCategoryId;
  order: number;
  status: 'active';
};

export const TOOL_CATEGORIES: Record<ToolCategoryId, { id: ToolCategoryId; title: string }> = {
  daily: { id: 'daily', title: '日常工具' },
  productivity: { id: 'productivity', title: '效率工具' },
};

export const TOOL_CATALOG: ToolMeta[] = [
  {
    id: 'eclock',
    title: '鹅打卡',
    description: '记录工作时间',
    pageUrl: '/tools/eclock',
    icon: Clock,
    color: '#137fec',
    gradient: ['#137fec', '#0A5BBF'],
    category: 'daily',
    order: 1,
    status: 'active',
  },
  {
    id: 'dmp',
    title: 'DMP打卡',
    description: '平台打卡助手',
    pageUrl: '/tools/dmp',
    icon: Database,
    color: '#7C3AED',
    gradient: ['#7C3AED', '#5B21B6'],
    category: 'daily',
    order: 2,
    status: 'active',
  },
  {
    id: 'news',
    title: '每日快讯',
    description: '行业动态资讯',
    pageUrl: '/tools/news',
    icon: FileText,
    color: '#F59E0B',
    gradient: ['#F59E0B', '#D97706'],
    category: 'daily',
    order: 3,
    status: 'active',
  },
  {
    id: 'pomodoro',
    title: '番茄钟',
    description: '专注时间管理',
    pageUrl: '/tools/pomodoro',
    icon: Timer,
    color: '#EF4444',
    gradient: ['#EF4444', '#DC2626'],
    category: 'productivity',
    order: 4,
    status: 'active',
  },
  {
    id: 'converter',
    title: '单位转换',
    description: '常用单位换算',
    pageUrl: '/tools/converter',
    icon: ArrowRightLeft,
    color: '#14B8A6',
    gradient: ['#14B8A6', '#0F766E'],
    category: 'productivity',
    order: 5,
    status: 'active',
  },
];

export const TOOL_MAP: Record<ToolId, ToolMeta> = TOOL_CATALOG.reduce(
  (acc, tool) => {
    acc[tool.id] = tool;
    return acc;
  },
  {} as Record<ToolId, ToolMeta>
);

export const DEFAULT_RECENT_TOOL_IDS: ToolId[] = [...TOOL_CATALOG]
  .sort((a, b) => a.order - b.order)
  .map((tool) => tool.id);

export function getToolsByCategory() {
  return Object.values(TOOL_CATEGORIES).map((category) => ({
    category,
    tools: TOOL_CATALOG.filter((tool) => tool.category === category.id).sort((a, b) => a.order - b.order),
  }));
}
