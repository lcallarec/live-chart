public class Example : Gtk.ApplicationWindow {    
    public Example(Gtk.Application app) {
        Object (application: app);

        this.title = "Live Chart Demo";
        // this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var cpu = new LiveChart.Serie("CPU 1 usage", new LiveChart.SmoothLineArea());
        cpu.line.color = { 0.8f, 0.8f, 0.1f, 1.0f };
        
        var config = new LiveChart.Config();
        config.y_axis.unit = "%";
        config.y_axis.tick_interval = 25;
        config.y_axis.fixed_max = LiveChart.cap(96);

        var chart = new LiveChart.Chart(config);

        var export_button = new Gtk.Button.with_label("Export to PNG");
		export_button.clicked.connect (() => {
            try {
                chart.to_png("export-fixed-max.png");
            } catch (Error e) {
                GLib.error(e.message);
            }
            
        });
        
        Gtk.Box box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
        box.append(export_button);
        box.append(chart);

        this.child = box;

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
     }
}

static int main (string[] args) {
    Gtk.init();

    var app = new Gtk.Application ("com.github.live-chart", GLib.ApplicationFlags.FLAGS_NONE);
    app.activate.connect (() => {
        var view = new Example(app);
        view.present();
    });

    return app.run (args);
}