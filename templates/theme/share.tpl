{{define "theme.share" -}}
    <style>
        .item {
            border-radius: 12px;
            background: #0a6e85;
            margin: 5px;
            padding: 6px;
            color: #ffffff;
            box-shadow: 1px 1px 1px 1px #888;
            line-height: 20px;
        }

        .layui-card-body > hr {
            box-shadow: 1px 1px 1px #888;
        }

        .item > img {
            width: 100%;
            height: 200px;
            border-radius: 10px;
            margin-bottom: 10px;
            box-shadow: 1px 1px 1px 1px #888;
            cursor: pointer;
        }

        .item > h4 > label {
            display: inline-block;
            overflow: hidden;
            margin-right: 5px;
        }

        .item > h4 > span {
            display: inline-block;
            width: 80%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .item > footer {
            margin-top: 10px;
            text-align: center;
        }

        .item > footer button {
            color: white;
        }

        .layui-btn + .layui-btn {
            margin: 2px;
        }

        #tags + button.layui-btn-primary {
            margin-left: 5px
        }
    </style>
{{end}}