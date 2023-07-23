public class LiveChart.Builder.App : Gtk.Window {
        
    public App() {
        this.title = "LiveChart Builder";
        this.destroy.connect(Gtk.main_quit);
        this.set_default_size(800, 350);

        var container = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);

        var conf_container = new ConfigurationWidget();

        conf_container.configuration_changed.connect((configuration) => {
            stdout.printf("Changed !\n");
        });


        var chart = new Gtk.Label("Chart  here");//new LiveChart.Chart();

        container.append(conf_container);
        container.append(chart);

        this.add(container);
    }
}

static int main (string[] args) {
    Gtk.init(ref args);

    var view = new LiveChart.Builder.App();
    view.present();

    Gtk.main();

    return 0;
}