namespace LiveChart.Builder { 

    public class WidgetRow : Gtk.Box {
        public WidgetRow() {
             Object(orientation: Gtk.Orientation.HORIZONTAL, spacing: 0);
        }

        public WidgetRow add_label(Gtk.Label label) {
            label.xalign = 0;
            label.set_size_request(150,-1);
            this.pack_start(label, false, true, 0);
            return this;
        }

        public WidgetRow add_selector(Gtk.Widget selector) {
            this.pack_end(selector, true, true, 0);
            return this;
        }
    }

    public struct DataSourceConfiguration {
        public double probability_of_change;
        public double min;
        public double max;
        public double refresh_in_ms;
        public DataSourceConfiguration() {
            probability_of_change = 50;
            min = -50;
            max = 50;
            refresh_in_ms = 1000;
        }
    }

    public class DataSourceWidget : Gtk.Box {

        private Gtk.Scale probability_of_change = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 0, 100, 10);
        private Gtk.SpinButton min = new Gtk.SpinButton.with_range(-10000, 10000, 1);
        private Gtk.SpinButton max = new Gtk.SpinButton.with_range(-10000, 10000, 1);
        private Gtk.SpinButton refresh_in_ms = new Gtk.SpinButton.with_range(50, 100000, 50);
        private DataSourceConfiguration configuration = DataSourceConfiguration();

        public signal void value_changed(DataSourceConfiguration configuration);

        public DataSourceWidget() {
            Object(orientation: Gtk.Orientation.VERTICAL, spacing: 5);
            setup();

            var row1 = new WidgetRow()
                .add_label(new Gtk.Label("Probability of change"))
                .add_selector(probability_of_change)
            ;

            var row2 = new WidgetRow()
                .add_label(new Gtk.Label("Min"))
                .add_selector(min)
            ;

            var row3 = new WidgetRow()
                .add_label(new Gtk.Label("Max"))
                .add_selector(max)
            ;

            var row4 = new WidgetRow()
                .add_label(new Gtk.Label("Refresh rate"))
                .add_selector(refresh_in_ms)
            ;

            connect_signals();

            this.pack_start(row1, false, false, 2);
            this.pack_start(row2, false, false, 2);
            this.pack_start(row3, false, false, 2);
            this.pack_start(row4, false, false, 2);
        }
        
        public Gtk.Expander with_expander(string label) {
            var expander = new Gtk.Expander(label);
            expander.add(this);
            return expander;
        }

        public DataSourceConfiguration get_configuration() {
            return configuration;
        }

        private void refresh_configuration() {
            configuration = {
                probability_of_change.get_value(),
                min.get_value(),
                max.get_value(),
                refresh_in_ms.get_value()
            };
        }

        private void connect_signals() {
            probability_of_change.value_changed.connect(() => {
                refresh_configuration();
                this.value_changed(configuration);
            });
            min.value_changed.connect(() => {
                refresh_configuration();
                this.value_changed(configuration);
            });
            max.value_changed.connect(() => {
                refresh_configuration();
                this.value_changed(configuration);
            });
            refresh_in_ms.value_changed.connect(() => {
                refresh_configuration();
                this.value_changed(configuration);
            });
        }

        private void setup() {
            probability_of_change.set_value(configuration.probability_of_change);
            min.set_value(configuration.min);
            max.set_value(configuration.max);
            refresh_in_ms.set_value(configuration.refresh_in_ms);
        }
    }
}
