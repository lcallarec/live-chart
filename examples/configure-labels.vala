public class Example : Gtk.Window {
        
    public Example() {
        this.title = "LiveChart Demo";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var heap = new LiveChart.Serie("HEAP", new LiveChart.SmoothLineArea());
        heap.main_color = { 0.3, 0.8, 0.1, 1.0};
        
        var rss = new LiveChart.Serie("RSS",  new LiveChart.Line());
        rss.main_color = { 0.8, 0.1, 0.1, 1.0};
        rss.line.dash = LiveChart.Dash() { dashes = {5} };
        rss.line.width = 4;

        var config = new LiveChart.Config();
        config.y_axis.unit = "MB";
        config.x_axis.tick_length = 60;
        config.x_axis.tick_interval = 10;
        config.x_axis.lines.visible = false;

        config.x_axis.labels.font.size = 8;
        config.x_axis.labels.font.color = {0, 1, 1, 1};
        config.x_axis.labels.font.weight = Cairo.FontWeight.BOLD;

        config.y_axis.labels.font.size = 15;
        config.y_axis.labels.font.color = {1, 0, 1, 0.8};
        config.y_axis.labels.font.weight = Cairo.FontWeight.NORMAL;
        config.y_axis.labels.font.slant = Cairo.FontSlant.ITALIC;

        var chart = new LiveChart.Chart(config);

        chart.legend.labels.font.size = 14;
        chart.legend.labels.font.color = {1, 1, 0, 1};
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

        var export_button = new Gtk.Button.with_label("Export to PNG");
		export_button.clicked.connect (() => {
            try {
                chart.to_png("export.png");
            } catch (Error e) {
                GLib.error(e.message);
            }
            
        });
        
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        box.pack_start(export_button, false, false, 5);
        box.pack_start(chart, true, true, 0);

        this.add(box);

     }
}

static int main (string[] args) {
    Gtk.init(ref args);

    var view = new Example();
    view.show_all();

    Gtk.main();

    return 0;
}