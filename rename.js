const fs = require('fs');
fs.renameSync('dist/AILFF-win32-x64', 'dist/PCHongguo-win32-x64');
fs.renameSync('dist/PCHongguo-win32-x64/AILFF.exe', 'dist/PCHongguo-win32-x64/PCHongguo.exe');
console.log('renamed to PCHongguo.exe');
