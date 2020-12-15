public class Example : Gtk.Window {
        
    public Example() {
        this.title = "Live Charts Demo";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 600);

        var demo1 = new Basic();
        var demo2 = new FixedMax();
        var demo3 = new HideParts();
        var demo4 = new AxisConfiguration();
        var demo5 = new BoundsAndThresholds();
        var demo6 = new ExperimentalStaticChart();

        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        var row1 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
        var row2 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
        var row3 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);

        box.pack_start(row1, true, true, 5);
        box.pack_start(row2, true, true, 5);
        box.pack_start(row3, true, true, 5);
        
        row1.pack_start(demo1.widget, true, true, 5);
        row1.pack_start(demo2.widget, true, true, 5);

        row2.pack_start(demo3.widget, true, true, 5);
        row2.pack_start(demo4.widget, true, true, 5);
        
        row3.pack_start(demo5.widget, true, true, 5);
        row3.pack_start(demo6.widget, true, true, 5);

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
