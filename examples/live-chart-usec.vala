public class Example : Gtk.Window {
    public Example(Gtk.Application app) {
        Object (application: app);

        this.title = "Live Chart Demo";
        // this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var smooth_line_area = new LiveChart.SmoothLineArea();

        var region = new LiveChart.Region
            .between (0, 200)
            .with_line_color({ 1.0f, 0.5f, 0.0f, 1.0f } )
            .with_area_color({ 1.0f, 0.5f, 0.0f, 0.5f } );

        smooth_line_area.region = region;

        var heat = new LiveChart.Serie("HEAT", smooth_line_area);
        
        heat.line.color = { 0.3f, 0.8f, 0.1f, 1.0f };
        
        var rss = new LiveChart.Serie("RSS",  new LiveChart.Line());
        rss.line.color = { 0.8f, 0.1f, 0.1f, 1.0f };

        var heap = new LiveChart.Serie("HEAP", new LiveChart.Bar());
        heap.line.color = { 0.1f, 0.8f, 0.7f, 1.0f };

        var config = new LiveChart.Config();
        config.y_axis.unit = "MB";
        config.x_axis.tick_length = 60;
        config.x_axis.tick_interval = 10;
        config.x_axis.lines.visible = false;
        config.x_axis.show_fraction = true;
        config.time.set_range("u");

        var chart = new LiveChart.Chart(config);
        
        chart.add_serie(heat);
        chart.add_serie(heap);
        chart.add_serie(rss);

        double rss_value = 200.0;
        var conv_us = config.time.conv_us;
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.13) {
                var new_value = Random.double_range(-50, 50.0);
                if (rss_value + new_value > 0) rss_value += new_value;
            }
            rss.add_with_timestamp(rss_value, GLib.get_real_time() / conv_us);
            return true;
        });

        var heap_value = 100.0;
        heap.add_with_timestamp(heap_value, GLib.get_real_time() / conv_us);
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.1) {
                var new_value = Random.double_range(-10, 10.0);
                if (heap_value + new_value > 0) heap_value += new_value;
            }
            heap.add_with_timestamp(heap_value, GLib.get_real_time() / conv_us);
            return true;
        });

        var heat_value = 150.0;
        heat.add_with_timestamp(heat_value, GLib.get_real_time() / conv_us);
        Timeout.add(2000, () => {
            if (Random.double_range(0.0, 1.0) > 0.2) {
                var new_value = Random.double_range(-100, 100.0);
                if (heat_value + new_value > 0) heat_value += new_value;
            }
            heat.add_with_timestamp(heat_value, GLib.get_real_time() / conv_us);
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
        
        int64 seek_sec = 10;
        int64 conv = chart.config.time.conv_sec;
        var seek_forward = new Gtk.Button.with_label(">>(%lldsec)".printf(seek_sec));
        seek_forward.clicked.connect(() => {
            chart.config.time.current += seek_sec * conv;
        });
        var seek_backward = new Gtk.Button.with_label("(%lldsec)<<".printf(-seek_sec));
        seek_backward.clicked.connect(() => {
            chart.config.time.current -= seek_sec * conv;
        });
        
        var pausing = false;
        var pause_btn = new Gtk.Button.with_label("pause/resume");
        pause_btn.clicked.connect(() => {
            pausing = !pausing;
            chart.refresh_every(100, pausing ? 0.0 : 1.0);
        });
        
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
        box.append(export_button);
        box.append(seek_forward);
        box.append(seek_backward);
        box.append(pause_btn);
        box.append(chart);
        this.child = box;
     }
}

int main (string[] args) {
    Gtk.init();

    var app = new Gtk.Application ("com.github.live-chart-usec", GLib.ApplicationFlags.FLAGS_NONE);
    app.activate.connect (() => {
        var view = new Example(app);
        view.present();
    });

    return app.run (args);
}