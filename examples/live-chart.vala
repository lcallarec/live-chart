public class Example : Gtk.Window {
        
    public Example() {
        this.title = "Live Chart Demo";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var heat = new LiveChart.Values();
        var curve = new LiveChart.Curve(heat);
        curve.color = { 0.3, 0.8, 0.1, 1.0};
        
        var rss = new LiveChart.Values();
        var line = new LiveChart.Line(rss);
        line.color = { 0.8, 0.1, 0.1, 1.0};

        var heap = new LiveChart.Values();
        var bar = new LiveChart.Bar(heap);
        bar.color = { 0.0, 0.1, 0.8, 1.0};

        var geometry = new LiveChart.Geometry();
        geometry.height = this.get_allocated_height();
        geometry.width = this.get_allocated_width();
        geometry.padding = { 30, 30, 30, 30 };
        geometry.auto_padding = true;

        var chart = new LiveChart.Chart(geometry);

        chart.add_serie(line);
        chart.add_serie(curve);
        chart.add_serie(bar);
        
        var grid = new LiveChart.Grid("MB");
        chart.grid = grid;
         
        this.add(chart);

        var rss_value = 300.0;
        chart.add_value(rss, rss_value);
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.3) {
                var new_value = Random.double_range(-100, 100.0);
                if (rss_value + new_value > 0) rss_value += new_value;
            }
            chart.add_value(rss, rss_value);
            return true;
        });

        var heap_value = 100.0;
        chart.add_value(heap, heap_value);
        Timeout.add(10000, () => {
            if (Random.double_range(0.0, 1.0) > 0.3) {
                var new_value = Random.double_range(-10, 10.0);
                if (heap_value + new_value > 0) heap_value += new_value;
            }
            chart.add_value(heap, heap_value);
            return true;
        });

        var heat_value = 200.0;
        chart.add_value(heat, heat_value);
        Timeout.add(5000, () => {
            if (Random.double_range(0.0, 1.0) > 0.1) {
                var new_value = Random.double_range(-20, 20.0);
                if (heat_value + new_value > 0) heat_value += new_value;
            }
            chart.add_value(heat, heat_value);
            return true;
        });
     }
}

static int main (string[] args) {
    Gtk.init(ref args);

    var view = new Example();
    view.show_all();

    Gtk.main();

    return 0;
}