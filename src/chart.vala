using Cairo;

namespace LiveChart {

    public errordomain ChartError
    {
        EXPORT_ERROR,
        SERIE_NOT_FOUND
    }

    public class Chart : Gtk.DrawingArea {
        private Cairo.Context? cairo_context = null;

        public Grid grid { get; set; default = new Grid(); }
        public Background background { get; set; default = new Background(); } 
        public Legend legend { get; set; default = new HorizontalLegend(); } 
        public Config config;
        public Series series;

        public int refresh_rate { get; private set; default = 100; } 

        private uint source_timeout = 0;
        private double play_ratio = 1.0;
        
        private int64 prev_time;
        public Chart(Config config = new Config()) {
            this.config = config;
            this.resize.connect((width, height) => {
                this.config.height = height;
                this.config.width = width;
            });

            this.set_draw_func(render);
            
            this.refresh_every(this.refresh_rate);

            series = new Series(this);
            this.destroy.connect(() => {
                refresh_every(0);
                remove_all_series();
            });
        }

        public void add_serie(Serie serie) {
            this.series.register(serie);
        }

        public void remove_serie(Serie serie){
            this.series.remove_serie(serie);
        }

        public void remove_all_series(){
            this.series.remove_all();
        }

        [Version (deprecated = true, deprecated_since = "1.7.0", replacement = "Retrieve the Serie from Chart.series (or from the serie you created) and add the value using serie.add")]
        public void add_value(Serie serie, double value) {
            serie.add(value);
        }

        [Version (deprecated = true, deprecated_since = "1.7.0", replacement = "Retrieve the Serie from Chart.series and add the value using serie.add")]        
        public void add_value_by_index(int serie_index, double value) throws ChartError {
            try {
                var serie = series.get(serie_index);
                add_value(serie, value);
            } catch (ChartError e) {
                throw e;
            }
        }

        public void add_unaware_timestamp_collection(Serie serie, Gee.Collection<double?> collection, int timespan_between_value) {
            var conv_us = this.config.time.conv_us;
            var ts = GLib.get_real_time() / conv_us - (collection.size * timespan_between_value);
            var values = serie.get_values();
            collection.foreach((value) => {
                ts += timespan_between_value;
                values.add({ts, value});
                config.y_axis.update_bounds(value);
                return true;
            });
        }

        public void add_unaware_timestamp_collection_by_index(int serie_index, Gee.Collection<double?> collection, int timespan_between_value) throws ChartError {
            try {
                var serie = series.get(serie_index);
                add_unaware_timestamp_collection(serie, collection, timespan_between_value);
            } catch (ChartError e) {
                throw e;
            }
        }

        public void to_png(string filename) throws Error {
            GLib.return_if_fail(null != cairo_context);

            var surface = cairo_context.get_target();
            surface.write_to_png(filename);
        }

        public void refresh_every(int refresh_rate, double play_ratio = 1.0) {
            this.play_ratio = play_ratio;
            this.refresh_rate = refresh_rate;
            if (source_timeout != 0) {
                GLib.Source.remove(source_timeout); 
                source_timeout = 0;
            }
            if(refresh_rate > 0){
                this.prev_time = GLib.get_monotonic_time() / this.config.time.conv_us;
                source_timeout = Timeout.add(refresh_rate, () => {
                    if(this.play_ratio != 0.0){
                        var now = GLib.get_monotonic_time() / this.config.time.conv_us;
                        config.time.current += (int64)((now - this.prev_time));
                        this.prev_time = now;
                    }
                    this.queue_draw();
                    return true;
                });
            }
        }

        private void render(Gtk.DrawingArea drawing_area, Context ctx, int width, int height) {
            cairo_context = ctx;
            config.configure(ctx, legend);
            
            this.background.draw(ctx, config);
            this.grid.draw(ctx, config);
            if(this.legend != null) this.legend.draw(ctx, config);

            var boundaries = this.config.boundaries();
            foreach (Drawable serie in this.series) {
                ctx.rectangle(boundaries.x.min, boundaries.y.min, boundaries.x.max, boundaries.y.max);
                ctx.clip();
                serie.draw(ctx, this.config);
            }
        }
    }
}