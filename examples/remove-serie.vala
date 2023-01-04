public class Example : Gtk.Window {
        
    public Example() {
        this.title = "Removable Series Demo(with sliding timeline)";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var smooth_line_area = new LiveChart.SmoothLineArea();

        var region = new LiveChart.Region
            .between (0, 200)
            .with_line_color({ 1.0, 0.5, 0.0, 1.0} )
            .with_area_color({ 1.0, 0.5, 0.0, 0.5} );

        smooth_line_area.region = region;

        var heat = new LiveChart.Serie("HEAT", smooth_line_area);
        
        heat.line.color = { 0.3, 0.8, 0.1, 1.0};
        
        var rss = new LiveChart.Serie("RSS",  new LiveChart.Line());
        rss.line.color = { 0.8, 0.1, 0.1, 1.0};

        var heap = new LiveChart.Serie("HEAP", new LiveChart.Bar());
        heap.line.color = { 0.1, 0.8, 0.7, 1.0};

        var config = new LiveChart.Config();
        config.y_axis.unit = "MB";
        config.x_axis.tick_length = 60;
        config.x_axis.tick_interval = 10;
        config.x_axis.lines.visible = true;
        config.x_axis.show_fraction = true;
        config.x_axis.slide_timeline = true;

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
        
        var heap_switch = new Gtk.Button.with_label("switch/heap");
        heap_switch.clicked.connect(() => {
            try{
                chart.series.get_by_name("HEAP");
                chart.remove_serie(heap);
            }
            catch(LiveChart.ChartError e){
                //chart doesn't contains -> add again.
                chart.add_serie(heap);
            }
        });
        
        var heat_switch = new Gtk.Button.with_label("switch/heat");
        heat_switch.clicked.connect(() => {
            try{
                chart.series.get_by_name("HEAT");
                chart.remove_serie(heat);
            }
            catch(LiveChart.ChartError e){
                //chart doesn't contains -> add again.
                chart.add_serie(heat);
            }
        });
        
        var rss_switch = new Gtk.Button.with_label("switch/rss");
        rss_switch.clicked.connect(() => {
            try{
                chart.series.get_by_name("RSS");
                chart.remove_serie(rss);
            }
            catch(LiveChart.ChartError e){
                //chart doesn't contains -> add again.
                chart.add_serie(rss);
            }
        });
        
        var all_remove = new Gtk.Button.with_label("remove_all_series");
        all_remove.clicked.connect(() => {
            chart.remove_all_series();
        });
        
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        box.pack_start(export_button, false, false, 5);
        box.pack_start(heap_switch, false, false, 5);
        box.pack_start(heat_switch, false, false, 5);
        box.pack_start(rss_switch, false, false, 5);
        box.pack_start(all_remove, false, false, 5);
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