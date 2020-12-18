using LiveChart;

public class BoundsAndThresholds {
        
    public Gtk.Box widget;

    public BoundsAndThresholds() {

        var heap = new SmoothLineAreaSerie("HEAP");
        heap.line.color = { 0.3, 0.8, 0.1, 1.0};
        
        var rss = new LineSerie("RSS");
        rss.line.color = { 0.8, 0.1, 0.8, 1.0};

        var threshold = new ThresholdLineSerie("threshold", 185.0);
        threshold.line.color = { 0.8, 0.1, 0.1, 1.0};

        var max = new MaxBoundLineSerie("MAX OF ALL SERIES");
        var mrss = new MaxBoundLineSerie.from_serie("MAX HEAP", rss);
        max.line.color = { 0.8, 0.5, 0.2, 1.0};
        mrss.line.color = { 0.5, 0, 1.0, 1.0};
        
        var config = new Config();
        config.y_axis.unit = "MB";
        config.x_axis.tick_length = 60;
        config.x_axis.tick_interval = 10;
        config.x_axis.lines.visible = false;

        var chart = new TimeChart(config);

        chart.add_serie(heap);
        chart.add_serie(rss);
        chart.add_serie(threshold);
        chart.add_serie(max);
        chart.add_serie(mrss);        

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

        var export_button = new Gtk.Button.with_label("Export to PNG");
		export_button.clicked.connect (() => {
            try {
                chart.to_png("export.png");
            } catch (Error e) {
                GLib.error(e.message);
            }
            
        });
        
        widget = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        var row1 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        var row2 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        widget.pack_start(row1, false, false, 5);
        widget.pack_start(row2, true, true, 5);

        row1.pack_start(new Gtk.Label("Bounds & thresholds"), false, false, 5);
        row2.pack_start(chart, true, true, 0);
     }
}