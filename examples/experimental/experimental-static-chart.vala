using LiveChart;

public class ExperimentalStaticChart {

    public Gtk.Box widget;

    public ExperimentalStaticChart() {

        var heap = new Static.StaticSerie("HEAP");
        heap.line.color = {0.8, 0.1, 0.9, 1};

        var chart = new Static.StaticChart();
        chart.add_serie(heap);
        chart.config.y_axis.unit = "°C";
        var categories = new Gee.ArrayList<string>();
        categories.add("Paris");
        categories.add("Moscow");
        categories.add("London");
        categories.add("Mexico");
        categories.add("Sevilla");
        categories.add("New-York");
        categories.add("Tokyo");
        categories.add("Shanghai");
        
        chart.set_categories(categories);

        heap.add("Paris", 24.5);
        heap.add("Moscow", 2.8);
        heap.add("London", 12.3);
        heap.add("Mexico", 27.9);
        heap.add("Sevilla", 32.8);
        heap.add("New-York", 8.7);
        heap.add("Tokyo", 14.3);
        heap.add("Shanghai", 22.9);

        widget = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        var row1 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        var row2 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        widget.pack_start(row1, false, false, 5);
        widget.pack_start(row2, true, true, 5);

        row1.pack_start(new Gtk.Label("Experimental static chart"), false, false, 5);
        row2.pack_start(chart, true, true, 0);
     }
}