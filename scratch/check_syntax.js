try {
    const fs = require('fs');
    const code = fs.readFileSync('d:/Tutien2d/tutien2d.com/tutien2d-helper.user.js', 'utf8');
    new Function(code);
    console.log("SYNTAX OK");
} catch (e) {
    console.error("SYNTAX ERROR:", e);
}


