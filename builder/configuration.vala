namespace LiveChart.Builder {
    
    public struct Configuration {
        DataSourceConfiguration datasource;
    }

    public class ConfigurationWidget : Gtk.Box {

        private Configuration configuration;
        public signal void configuration_changed(Configuration configuration);
        
        public ConfigurationWidget() {
            Object(orientation: Gtk.Orientation.VERTICAL, spacing: 0);
            
            var datasources = new DataSourceWidget();
            
            configuration = Configuration() {
                datasource = datasources.get_configuration()
            };

            datasources.value_changed.connect(() => {
                stdout.printf("Global Configuration refreshed\n");
                configuration = Configuration() {
                    datasource = datasources.get_configuration()
                };
                configuration_changed(configuration);
            });

            pack_start(datasources.with_expander("Datasources"), false, false, 0);
        }     
        
        //  public uint8 create_data_source() {
    
        //  }
        
        //  var density_combo = new Gtk.ComboBoxText();
        //      density_combo.append(null, "LOW");
        //      density_combo.append(null, "MEDIUM");
        //      density_combo.append(null, "HIGH");
            
        //      density_combo.active = 0;
    
        //  	density_combo.changed.connect (() => {
        //          stdout.printf("density_combo.active %d\n", density_combo.active);
        //          config.y_axis.tick_density = (LiveChart.Density) density_combo.active;
        //      });
    }
}
