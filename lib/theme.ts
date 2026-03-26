import { DarkTheme, DefaultTheme, type Theme } from '@react-navigation/native';
 
export const THEME = {
  light: {
    background: 'hsl(220 14% 96%)',
    foreground: 'hsl(220 20% 10%)',
    card: 'hsl(0 0% 100%)',
    cardForeground: 'hsl(220 20% 10%)',
    popover: 'hsl(0 0% 100%)',
    popoverForeground: 'hsl(220 20% 10%)',
    primary: 'hsl(211 89% 50%)', // #137fec
    primaryForeground: 'hsl(0 0% 100%)',
    secondary: 'hsl(220 14% 93%)',
    secondaryForeground: 'hsl(220 10% 40%)',
    muted: 'hsl(220 14% 93%)',
    mutedForeground: 'hsl(220 10% 46%)',
    accent: 'hsl(211 89% 95%)',
    accentForeground: 'hsl(211 89% 35%)',
    destructive: 'hsl(0 84% 60%)',
    destructiveForeground: 'hsl(0 0% 100%)',
    border: 'hsl(220 13% 88%)',
    input: 'hsl(220 13% 88%)',
    ring: 'hsl(211 89% 50%)',
    radius: '0.5rem',
  },
  dark: {
    background: 'hsl(225 15% 8%)', // #111318
    foreground: 'hsl(210 20% 95%)', // #EDF1F5
    card: 'hsl(225 14% 12%)', // #181B22
    cardForeground: 'hsl(210 20% 95%)',
    popover: 'hsl(225 14% 14%)',
    popoverForeground: 'hsl(210 20% 95%)',
    primary: 'hsl(211 89% 55%)', // #2E90F0
    primaryForeground: 'hsl(0 0% 100%)',
    secondary: 'hsl(225 14% 16%)',
    secondaryForeground: 'hsl(220 10% 65%)',
    muted: 'hsl(225 14% 16%)',
    mutedForeground: 'hsl(220 10% 55%)',
    accent: 'hsl(225 14% 18%)',
    accentForeground: 'hsl(210 20% 95%)',
    destructive: 'hsl(0 84% 55%)',
    destructiveForeground: 'hsl(0 0% 100%)',
    border: 'hsl(225 12% 18%)',
    input: 'hsl(225 12% 18%)',
    ring: 'hsl(211 89% 55%)',
    radius: '0.5rem',
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
