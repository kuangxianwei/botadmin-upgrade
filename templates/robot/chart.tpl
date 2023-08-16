<div class="layui-card">
    <div class="layui-card-body">
        <canvas id="robot-chart"></canvas>
    </div>
    <div class="layui-card-body" style="text-align: center">
        <div class="layui-inline">
            <label class="layui-form-label">显示:</label>
        </div>
        <div class="layui-btn-group">
            <button class="layui-btn layui-btn-primary" lay-event="day">天</button>
            <button class="layui-btn layui-btn-primary" lay-event="week">周</button>
            <button class="layui-btn" lay-event="month">月</button>
        </div>
    </div>
</div>
<script src="/static/layui/layui.js"></script>
<script src="/static/modules/chart.js"></script>
<script>
    layui.use(['index', 'main'], function () {
        let main = layui.main;
        const ctx = document.getElementById('robot-chart'), chart = new Chart(ctx, {
            type: 'line',
            data: {{.data}},
            options: {scales: {y: {beginAtZero: true}}}
        }), update = (data) => {
            main.request({
                data: data,
                done: function (res) {
                    chart.data.datasets = res.data.datasets;
                    chart.data.labels = res.data.labels;
                    chart.update();
                    return false;
                }
            });
        };
        $(document).on('click', '[lay-event]', function () {
            let $this = $(this);
            $this.siblings().addClass('layui-btn-primary');
            $this.removeClass('layui-btn-primary');
            switch ($this.attr('lay-event')) {
                case 'day':
                    update({action: 'day'});
                    break;
                case 'week':
                    update({action: 'week'});
                    break;
                case 'month':
                    update({action: 'month'});
                    break;
            }
        })
    });
</script>