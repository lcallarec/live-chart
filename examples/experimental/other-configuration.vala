using LiveChart;

public class AxisConfiguration {
        
    public Gtk.Box widget;

    public AxisConfiguration() {
        var heap = new SmoothLineAreaSerie("HEAP");
        heap.line.color = { 0.3, 0.8, 0.1, 1.0};
        
        var rss = new LineSerie("RSS");
        rss.line.color = { 0.8, 0.1, 0.1, 1.0};
        rss.line.dash = Dash() { dashes = {5} };
        rss.line.width = 2;

        var config = new Config();
        config.y_axis.unit = "MB";
        config.x_axis.tick_length = 60;
        config.x_axis.tick_interval = 10;
        config.x_axis.lines.visible = false;

        config.x_axis.labels.font.size = 8;
        config.x_axis.labels.font.color = {1, 0.7, 0.7, 1};
        config.x_axis.labels.font.weight = Cairo.FontWeight.BOLD;

        config.y_axis.labels.font.size = 8;
        config.y_axis.labels.font.color = {1, 1, 1, 1};
        config.y_axis.labels.font.weight = Cairo.FontWeight.NORMAL;
        config.y_axis.labels.font.slant = Cairo.FontSlant.ITALIC;

        var chart = new TimeChart(config);

        chart.background.gradient = {from: {0.1, 0.1, 0.1, 1}, to: {0.12, 0.12, 0.12, 1}};

        chart.legend.labels.font.size = 10;
        chart.legend.labels.font.color = {0.5, 0.5, 0.5, 1};
        chart.legend.labels.font.weight = Cairo.FontWeight.BOLD;

        chart.add_serie(heap);
        chart.add_serie(rss);
         
        double rss_value = 200.0;
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.13) {
                var new_value = Random.double_range(-50, 50.0);
                if (rss_value + new_value > 0) rss_value += new_value;
            }
            rss.add(rss_value);
            return true;
        });

        var heap_value = 200.0;
        heap.add(heap_value);
        Timeout.add(2000, () => {
            if (Random.double_range(0.0, 1.0) > 0.2) {
                var new_value = Random.double_range(-100, 100.0);
                if (heap_value + new_value > 0) heap_value += new_value;
            }
            heap.add(heap_value);
            return true;
        });

        widget = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        var row1 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        var row2 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        widget.pack_start(row1, false, false, 5);
        widget.pack_start(row2, true, true, 5);

        row1.pack_start(new Gtk.Label("Axis, line & background configurations"), false, false, 5);
        row2.pack_start(chart, true, true, 0);
     }
}