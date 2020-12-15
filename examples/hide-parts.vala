using LiveChart;

public class HideParts {
    public Gtk.Box widget;
    public HideParts() {

        var cpu = new Serie("CPU 1 usage", new SmoothLineArea());
        cpu.line.color = { 1, 0.8, 0.1, 1.0};

        var config = new Config();
        config.padding = Padding() { smart = AutoPadding.NONE, top = 0, right = 0, bottom = 0, left = 0};

        var chart = new Chart(config);
        chart.legend.visible = false;
        chart.grid.visible = false;

        chart.add_serie(cpu);
         
        var cpu_value = 50.0;
        cpu.add(cpu_value);
        Timeout.add(1000, () => {
            if (Random.double_range(0.0, 1.0) > 0.2) {
                var new_value = Random.double_range(-25, 25.0);
                if (cpu_value + new_value > 100.0) {
                    cpu_value = 100.0;
                } else if (cpu_value + new_value < 0.0) {
                    cpu_value = 0.0;
                } else {
                    cpu_value += new_value;
                }
            }
           
            cpu.add(cpu_value);
            return true;
        });

        widget = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        var row1 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        var row2 = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        widget.pack_start(row1, false, false, 5);
        widget.pack_start(row2, true, true, 5);

        row1.pack_start(new Gtk.Label("All parts may be hidden"), false, false, 5);
        row2.pack_start(chart, true, true, 0);
     }
}