const fs = require('fs');
fs.renameSync('dist/AILFF-win32-x64', 'dist/AI类风湿-win32-x64');
fs.renameSync('dist/AI类风湿-win32-x64/AILFF.exe', 'dist/AI类风湿-win32-x64/AI类风湿.exe');
console.log('renamed to AI类风湿.exe');
