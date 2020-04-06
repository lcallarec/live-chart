public class Example : Gtk.Window {
        
    public Example() {
        this.title = "Live Chart Demo";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var cpu = new LiveChart.Serie("CPU 1 usage", new LiveChart.SmoothLineArea());
        cpu.set_main_color({ 1, 0.8, 0.1, 1.0});

        var config = new LiveChart.Config();
        config.padding = LiveChart.Padding() { smart = null, top = 0, right = 0, bottom = 0, left = 0};

        var chart = new LiveChart.Chart(config);
        chart.legend.visible = false;
        chart.grid.visible = false;

        this.add(chart);

        chart.add_serie(cpu);
         
        var cpu_value = 50.0;
        chart.add_value(cpu, cpu_value);
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
           
            chart.add_value(cpu, cpu_value);
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