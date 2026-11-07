const { spawnSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const root = __dirname;
const htmlPath = path.resolve(root, 'index.html');
const html = fs.readFileSync(htmlPath, 'utf-8');
const b64 = Buffer.from(html, 'utf-8').toString('base64');
const dataUrl = 'data:text/html;base64,' + b64;

console.log('[build] index.html bytes :', Buffer.byteLength(html));
console.log('[build] data url length  :', dataUrl.length);

// 1) 先用合法占位 URL 构建外壳（nativefier 对非 http(s)/file 参数会强制补 https://，
//    且不会把本地文件复制进程序，因此不能直接传本地文件；构建后我们把网页以 data URL 写回）
const r = spawnSync(
  'npx',
  [
    'nativefier',
    '--name', 'AILFF',
    '--platform', 'windows',
    '--arch', 'x64',
    '--single-instance',
    'https://example.com',
    'dist'
  ],
  { stdio: 'inherit', shell: true, cwd: root }
);
if (r.status !== 0) process.exit(r.status === null ? 1 : r.status);

// 2) 把整页 HTML 以 data URL 形式写进 nativefier.json，做到自包含、可分发
const nfPath = path.resolve(root, 'dist/AILFF-win32-x64/resources/app/nativefier.json');
const nf = JSON.parse(fs.readFileSync(nfPath, 'utf-8'));
nf.targetUrl = dataUrl;
fs.writeFileSync(nfPath, JSON.stringify(nf));
console.log('[build] embedded index.html into nativefier.json (self-contained).');
