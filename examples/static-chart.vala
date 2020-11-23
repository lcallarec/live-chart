public class Example : Gtk.Window {
        
    public Example() {
        this.title = "Static Chart Demo";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var heap = new LiveChart.Static.StaticSerie("HEAP");
        
        var chart = new LiveChart.Static.StaticChart();
        chart.add_serie(heap);
        chart.config.y_axis.unit = "MB";
        var categories = new Gee.ArrayList<string>();
        categories.add("paris");
        categories.add("london");
        categories.add("mexico");
        categories.add("seville");
        chart.set_categories(categories);
        heap.add("paris", 5000);
        heap.add("london", 7000);
        heap.add("mexico", 0);
        heap.add("seville", 3000);

        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
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
