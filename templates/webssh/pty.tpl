<!doctype html>
<html lang="en">
<head>
    <link rel="/static/webssh/xterm.css"/>
    <script src="/static/webssh/xterm.js"></script>
    <title></title>
</head>
<body>
<div id="terminal"></div>
<script>
    const term = new Terminal({
        rendererType: 'canvas',
        cols: 100,
        rows: 20,
        useStyle: true,
        cursorBlink: true,
        theme: {
            foreground: '#7e9192',
            background: '#002833',
        }
    });
    term.open(document.getElementById('terminal'));
    term.write('Hello from \x1B[1;3;31mxterm.js\x1B[0m $ ')
</script>
</body>
</html>