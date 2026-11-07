const fs = require('fs');
fs.renameSync('dist/AILFF-win32-x64', 'dist/AIHongguoPromo-win32-x64');
fs.renameSync('dist/AIHongguoPromo-win32-x64/AILFF.exe', 'dist/AIHongguoPromo-win32-x64/AIHongguoPromo.exe');
console.log('renamed to AIHongguoPromo.exe');
