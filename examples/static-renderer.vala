public class Example : Gtk.ApplicationWindow {    
    public Example(Gtk.Application app) {
        Object (application: app);

        this.title = "Live Chart Demo";
        // this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var heap = new LiveChart.Serie("HEAP", new LiveChart.SmoothLineArea());
        heap.line.color = { 0.3f, 0.8f, 0.1f, 1.0f };
        
        var rss = new LiveChart.Serie("RSS",  new LiveChart.Line());
        rss.line.color = { 0.8f, 0.1f, 0.8f, 1.0f };

        var threshold = new LiveChart.Serie("threshold", new LiveChart.ThresholdLine(185.0));
        threshold.line.color = { 0.8f, 0.1f, 0.1f, 1.0f };

        var max = new LiveChart.Serie("MAX OF ALL SERIES", new LiveChart.MaxBoundLine());
        var mrss = new LiveChart.Serie("MAX HEAP", new LiveChart.MaxBoundLine.from_serie(rss));
        max.line.color = { 0.8f, 0.5f, 0.2f, 1.0f };
        mrss.line.color = { 0.5f, 0f, 1.0f, 1.0f };
        
        var config = new LiveChart.Config();
        config.y_axis.unit = "MB";
        config.x_axis.tick_length = 60;
        config.x_axis.tick_interval = 10;
        config.x_axis.lines.visible = false;

        var chart = new LiveChart.Chart(config);
        chart.vexpand = true;
        chart.vexpand = true;

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
                chart.to_png("export-static-renderer.png");
            } catch (Error e) {
                GLib.error(e.message);
            }
            
        });
        
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        box.append(export_button);
        box.append(chart);

        this.child = box;

     }
}

static int main (string[] args) {
    Gtk.init();

    var app = new Gtk.Application ("com.github.live-chart", GLib.ApplicationFlags.FLAGS_NONE);
    app.activate.connect (() => {
        var view = new Example(app);
        view.present();
    });

    return app.run (args);
}