private class DestructChart: LiveChart.Chart {
    ~DestructChart(){
        print("call destructor chain including LiveChart.Chart\n");
    }
}

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

        var chart = new DestructChart();
        
        chart.add_serie(heat);
        chart.add_serie(heap);
        chart.add_serie(rss);
        chart.destroy.connect(() => {
            print("chart.destroy\n");
        });

        double rss_value = 200.0;
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.13) {
                var new_value = Random.double_range(-50, 50.0);
                if (rss_value + new_value > 0) rss_value += new_value;
            }
            rss.add(rss_value);
            return true;
        });

        var heap_value = 100.0;
        heap.add(heap_value);
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.1) {
                var new_value = Random.double_range(-10, 10.0);
                if (heap_value + new_value > 0) heap_value += new_value;
            }
            heap.add(heap_value);
            return true;
        });

        var heat_value = 150.0;
        heat.add(heat_value);
        Timeout.add(2000, () => {
            if (Random.double_range(0.0, 1.0) > 0.2) {
                var new_value = Random.double_range(-100, 100.0);
                if (heat_value + new_value > 0) heat_value += new_value;
            }
            heat.add(heat_value);
            return true;
        });
        
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);
        box.append(chart);

        this.child = box;
        
        var replace_chart = new Gtk.Button.with_label("replace chart");
        replace_chart.clicked.connect(() => {
            print("replace chart\n");
            //chart.remove_all_series();
            box.remove(chart);
            
            /// \note Calling to stop auto-refresh is strongly recommended before removing from parent to avoid memory leak!!
            chart.refresh_every(-1);
            
            chart = new DestructChart();
            chart.add_serie(heat);
            chart.add_serie(heap);
            chart.add_serie(rss);
            chart.destroy.connect(() => {
                print("chart.destroy\n");
            });
            box.append(chart);
            chart.visible = true;
        });
        box.append(replace_chart);

     }
}

int main (string[] args) {
    Gtk.init();

    var app = new Gtk.Application ("com.github.replace-chart", GLib.ApplicationFlags.FLAGS_NONE);
    app.activate.connect (() => {
        var view = new Example(app);
        view.present();
    });

    return app.run (args);
}