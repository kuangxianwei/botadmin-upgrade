{{define "codemirror" -}}
    <link href="/static/codemirror/lib/codemirror.css" rel="stylesheet">
    <link href="/static/codemirror/theme/3024-night.css" rel="stylesheet">
    <script src="/static/codemirror/lib/codemirror.js"></script>
    <script src="/static/codemirror/mode/javascript/javascript.js"></script>
    <script id="codemirror">
        function code(id, options) {
            let elem = document.getElementById(typeof id === 'string' ? id : "editor");
            if (elem) {
                let editor = CodeMirror.fromTextArea(elem, Object.assign({
                    lineNumbers: true,
                    styleActiveLine: true,
                    matchBrackets: true,
                    theme: "3024-night",
                }, options || (Object.prototype.toString.call(id) === '[object Object]' ? id : {})));
                editor.on('change', editor.save);
                return editor;
            }
        }
    </script>
{{end -}}
{{define "codemirrorAll" -}}
    <link href="/static/codemirror/lib/codemirror.css" rel="stylesheet">
    <link href="/static/codemirror/theme/3024-night.css" rel="stylesheet">
    <script src="/static/codemirror/lib/codemirror.js"></script>
    <script src="/static/codemirror/mode/javascript/javascript.js"></script>
    <link rel="stylesheet" href="/static/codemirror/addon/hint/show-hint.css">
    <script src="/static/codemirror/addon/hint/show-hint.js"></script>
    <script src="/static/codemirror/addon/hint/xml-hint.js"></script>
    <script src="/static/codemirror/addon/hint/html-hint.js"></script>
    <script src="/static/codemirror/mode/xml/xml.js"></script>
    <script src="/static/codemirror/mode/css/css.js"></script>
    <script src="/static/codemirror/mode/htmlmixed/htmlmixed.js"></script>
    <script id="codemirror">
        function code(id, options) {
            let elem = document.getElementById(typeof id === 'string' ? id : "editor");
            if (elem) {
                let editor = CodeMirror.fromTextArea(elem, Object.assign({
                    lineNumbers: true,
                    styleActiveLine: true,
                    matchBrackets: true,
                    theme: "3024-night",
                    mode: "javascript",
                }, options || (Object.prototype.toString.call(id) === '[object Object]' ? id : {})));
                editor.on('change', editor.save);
                return editor;
            }
        }
    </script>
{{end -}}