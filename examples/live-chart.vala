public class Example : Gtk.Window {
        
    public Example() {
        this.title = "Live Chart Demo";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);


        var heat = new LiveChart.Serie("HEAT", new LiveChart.SmoothLine());
        heat.set_main_color({ 0.3, 0.8, 0.1, 1.0});
        
        var rss = new LiveChart.Serie("RSS");
        rss.set_main_color({ 0.8, 0.1, 0.1, 1.0});

        var heap = new LiveChart.Serie("HEAP", new LiveChart.Bar());
        heap.set_main_color({ 0.0, 0.1, 0.8, 1.0});

        var chart = new LiveChart.Chart();
        chart.legend = new LiveChart.HorizontalLegend();
        
        chart.add_serie(heat);
        chart.add_serie(heap);
        chart.add_serie(rss);
        
        var grid = new LiveChart.FixedTickIntervalGrid("MB", 100);
        chart.grid = grid;
         
        var rss_value = 300.0;
        chart.add_value(rss, rss_value);
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.3) {
                var new_value = Random.double_range(-10, 10.0);
                if (rss_value + new_value > 0) rss_value += new_value;
            }
            chart.add_value(rss, rss_value);
            return true;
        });

        var heap_value = 50.0;
        chart.add_value(heap, heap_value);
        Timeout.add(10000, () => {
            if (Random.double_range(0.0, 1.0) > 0.1) {
                var new_value = Random.double_range(-10, 10.0);
                if (heap_value + new_value > 0) heap_value += new_value;
            }
            chart.add_value(heap, heap_value);
            return true;
        });

        var heat_value = 200.0;
        chart.add_value(heat, heat_value);
        Timeout.add(2000, () => {
            if (Random.double_range(0.0, 1.0) > 0.2) {
                var new_value = Random.double_range(-100, 100.0);
                if (heat_value + new_value > 0) heat_value += new_value;
            }
            chart.add_value(heat, heat_value);
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