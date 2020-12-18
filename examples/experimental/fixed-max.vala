using LiveChart;

public class FixedMax {
    
    public Gtk.Box widget;

    public FixedMax() {

        var cpu = new SmoothLineAreaSerie("CPU 1 USAGE");
        cpu.line.color = { 0.8, 0.8, 0.1, 1.0};
        
        var config = new Config();
        config.y_axis.unit = "%";
        config.y_axis.tick_interval = 25;
        config.y_axis.fixed_max = cap(96);

        var chart = new TimeChart(config);
        chart.grid.gradient = {from: {0.2, 0.1, 0.1, 1}, to: {0.12, 0.12, 0.12, 1}};

        var export_button = new Gtk.Button.with_label("Export to PNG");
		export_button.clicked.connect (() => {
            try {
                chart.to_png("export-fixed-max.png");
            } catch (Error e) {
                GLib.error(e.message);
            }
            
        });
        
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

        row1.pack_start(new Gtk.Label("Fixed Y-axis"), false, false, 5);
        row1.pack_end(export_button, false, false, 5);
        row2.pack_start(chart, true, true, 0);

     }
}
