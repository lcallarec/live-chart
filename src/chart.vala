using Cairo;

namespace LiveChart {

    public errordomain ChartError
    {
        EXPORT_ERROR,
        SERIE_NOT_FOUND
    }

    public class Chart : Gtk.DrawingArea {

        public Grid grid { get; set; default = new Grid(); }
        public Background background { get; set; default = new Background(); } 
        public Legend legend { get; set; default = new HorizontalLegend(); } 
        public Config config;
        public Series series;

        private uint source_timeout = 0;

        public Chart(Config config = new Config()) {
            this.config = config;
            this.resize.connect((width, height) => {
                this.config.height = height;
                this.config.width = width;
            });

            this.set_draw_func(render);
            
            this.refresh_every(100);

            series = new Series(this);
        }

        public void add_serie(Serie serie) {
            this.series.register(serie);
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
            var ts = GLib.get_real_time() / 1000 - (collection.size * timespan_between_value);
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
            //FIXME
            /* var window = this.root() as Gtk.Window;
            if (window == null) {
                throw new ChartError.EXPORT_ERROR("Chart is not realized yet");
            }
            var pixbuff = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
            if (pixbuff != null) {
                pixbuff.save(filename, "png");
            } */
        }

        public void refresh_every(int ms) {
            if (source_timeout != 0) {
                GLib.Source.remove(source_timeout); 
            }
            source_timeout = Timeout.add(ms, () => {
                this.queue_draw();
                return true;
            });
        }

        private void render(Gtk.DrawingArea drawing_area, Context ctx, int width, int height) {
            
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