// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';
import icon from 'astro-icon';

export default defineConfig({
  site: 'https://supernova1426.github.io',
  base: '/Portfolio_BD1_2026-1',
  integrations: [icon()],
  vite: {
    plugins: [tailwindcss()]
  }
});
