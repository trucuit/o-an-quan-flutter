#!/usr/bin/env node
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';
import { writeFileSync, mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const OUT = join(__dirname, '../docs/screenshots/ui-recheck');
mkdirSync(OUT, { recursive: true });

const DEVICE = 'emulator-5554';
const PKG = 'com.game.o_an_quan';

const transport = new StdioClientTransport({
  command: 'npx',
  args: ['-y', '@mobilenext/mobile-mcp@latest'],
});
const client = new Client({ name: 'ui-recheck', version: '1.0.0' }, { capabilities: {} });
await client.connect(transport);

async function call(tool, args = {}) {
  const res = await client.callTool({ name: tool, arguments: { device: DEVICE, ...args } });
  const text = res.content?.map((c) => c.text).filter(Boolean).join('\n') ?? '';
  return { res, text };
}

async function screenshot(name) {
  const { res } = await call('mobile_take_screenshot', {});
  const img = res.content?.find((c) => c.type === 'image');
  if (img?.data) {
    const path = join(OUT, `${name}.png`);
    writeFileSync(path, Buffer.from(img.data, 'base64'));
    console.log(`saved ${path}`);
    return path;
  }
  console.warn(`no image for ${name}:`, JSON.stringify(res.content?.slice(0, 2)));
  return null;
}

async function listElements() {
  const { text } = await call('mobile_list_elements_on_screen', {});
  return text;
}

async function tap(x, y, label = '') {
  console.log(`tap ${label} (${x},${y})`);
  await call('mobile_click_on_screen_at_coordinates', { x, y });
  await sleep(800);
}

function sleep(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

// Launch
await call('mobile_terminate_app', { packageName: PKG });
await sleep(500);
await call('mobile_launch_app', { packageName: PKG });
await sleep(2000);

const sizeRes = await call('mobile_get_screen_size', {});
console.log('screen:', sizeRes.text);

// 01 Menu
await screenshot('01_menu');
const menuA11y = await listElements();
writeFileSync(join(OUT, '01_menu_a11y.txt'), menuA11y);

// Tap "Hướng dẫn" bar — bottom center
const { text: menuEls } = await call('mobile_list_elements_on_screen', {});
// landscape ~ 2400x1080 logical - tutorial bar near bottom center
await tap(1200, 950, 'tutorial');
await screenshot('02_tutorial_step1');
writeFileSync(join(OUT, '02_tutorial_a11y.txt'), await listElements());

// Next through tutorial (right nav button ~ bottom right)
for (let i = 2; i <= 6; i++) {
  await tap(2200, 980, `tutorial-next-${i}`);
  await screenshot(`02_tutorial_step${i}`);
}

// Back to menu via back button top left
await tap(80, 80, 'tutorial-back');
await sleep(600);

// PvP game — top-left tile area
await screenshot('03_menu_before_pvp');
await tap(600, 450, 'pvp-tile');
await sleep(1500);
await screenshot('04_game_pvp_initial');
writeFileSync(join(OUT, '04_game_pvp_a11y.txt'), await listElements());

// Tap bottom citizen pit P1 (approx center-bottom of board)
await tap(1200, 700, 'pit-tap');
await sleep(600);
await screenshot('05_direction_overlay');

// Cancel direction — tap scrim or cancel button
await tap(1200, 200, 'scrim-cancel');
await sleep(400);

// Rules button — bottom right HUD
await tap(2280, 1020, 'rules');
await sleep(600);
await screenshot('06_rules_dialog');
writeFileSync(join(OUT, '06_rules_a11y.txt'), await listElements());
await tap(1200, 540, 'dismiss-rules');

// Easy AI from menu
await tap(80, 80, 'back-menu');
await sleep(600);
await tap(1800, 450, 'easy-ai');
await sleep(1500);
await screenshot('07_game_easy_ai');

await client.close();
console.log('UI recheck complete');