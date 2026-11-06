$userScript = Get-Content "d:\Tutien2d\tutien2d.com\tutien2d-helper.user.js" -Raw
$html = @"
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body>
<pre id="err"></pre>
<script>
window.onerror = function(msg, url, line, col, error) {
    document.getElementById('err').textContent = "ERROR: " + msg + " at line " + line + ":" + col + (error ? "\n" + error.stack : "");
};
</script>
<script>
try {
$userScript
    document.getElementById('err').textContent = "ALL GOOD: TTBot=" + typeof window.TTBot;
} catch(e) {
    document.getElementById('err').textContent = "CATCH ERROR: " + e.message + "\n" + e.stack;
}
</script>
</body>
</html>
"@
Set-Content -Path "d:\Tutien2d\tutien2d.com\scratch\check_inline_syntax.html" -Value $html

