import { DarkTheme, DefaultTheme, type Theme } from '@react-navigation/native';
 
export const THEME = {
  light: {
    background: 'hsl(240 5% 96%)', // #F2F2F7
    foreground: 'hsl(0 0% 0%)',
    card: 'hsl(0 0% 100%)',
    cardForeground: 'hsl(0 0% 0%)',
    popover: 'hsl(0 0% 100%)',
    popoverForeground: 'hsl(0 0% 0%)',
    primary: 'hsl(211 100% 50%)', // #007AFF
    primaryForeground: 'hsl(0 0% 100%)',
    secondary: 'hsl(240 5% 96%)',
    secondaryForeground: 'hsl(240 5% 38%)', // #3C3C43 60%
    muted: 'hsl(240 5% 96%)',
    mutedForeground: 'hsl(240 5% 38%)', // #3C3C43 60%
    accent: 'hsl(240 5% 90%)', // #E5E5EA
    accentForeground: 'hsl(0 0% 0%)',
    destructive: 'hsl(0 100% 50%)', // #FF3B30
    destructiveForeground: 'hsl(0 0% 100%)',
    border: 'hsl(240 1% 78%)', // #C6C6C8
    input: 'hsl(240 1% 78%)',
    ring: 'hsl(211 100% 50%)',
    radius: '0.625rem',
  },
  dark: {
    background: 'hsl(0 0% 0%)',
    foreground: 'hsl(0 0% 100%)',
    card: 'hsl(240 4% 11%)', // #1C1C1E
    cardForeground: 'hsl(0 0% 100%)',
    popover: 'hsl(240 4% 11%)',
    popoverForeground: 'hsl(0 0% 100%)',
    primary: 'hsl(211 100% 50%)', // #0A84FF
    primaryForeground: 'hsl(0 0% 100%)',
    secondary: 'hsl(240 4% 16%)',
    secondaryForeground: 'hsl(240 4% 60%)', // #EBEBF5 60%
    muted: 'hsl(240 4% 16%)',
    mutedForeground: 'hsl(240 4% 60%)', // #EBEBF5 60%
    accent: 'hsl(240 2% 23%)', // #3A3A3C
    accentForeground: 'hsl(0 0% 100%)',
    destructive: 'hsl(0 100% 45%)', // #FF453A
    destructiveForeground: 'hsl(0 0% 100%)',
    border: 'hsl(240 2% 22%)', // #38383A
    input: 'hsl(240 2% 22%)',
    ring: 'hsl(211 100% 50%)',
    radius: '0.625rem',
  },
};
 
export const NAV_THEME: Record<'light' | 'dark', Theme> = {
  light: {
    ...DefaultTheme,
    colors: {
      background: THEME.light.background,
      border: THEME.light.border,
      card: THEME.light.card,
      notification: THEME.light.destructive,
      primary: THEME.light.primary,
      text: THEME.light.foreground,
    },
  },
  dark: {
    ...DarkTheme,
    colors: {
      background: THEME.dark.background,
      border: THEME.dark.border,
      card: THEME.dark.card,
      notification: THEME.dark.destructive,
      primary: THEME.dark.primary,
      text: THEME.dark.foreground,
    },
  },
};
