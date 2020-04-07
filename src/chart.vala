using Cairo;

namespace LiveChart {

    public errordomain ChartError
    {
        EXPORT_ERROR
    }

    public class Chart : Gtk.DrawingArea {

        public Grid grid { get; set; default = new Grid(); }
        public Drawable background { get; set; default = new Background(); } 
        public Legend legend { get; set; default = new HorizontalLegend(); } 
        public Config config;

        private Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();
        private uint source_timeout = 0;

        public Chart(Config config = new Config()) {
            this.config = config;
            this.size_allocate.connect((allocation) => {
                this.config.height = allocation.height;
                this.config.width = allocation.width;
            });

            this.draw.connect(render);
            
            this.refresh_every(100);
        }

        public void add_serie(Serie serie) {
            this.series.add(serie);
            if(this.legend != null) this.legend.add_legend(serie);
        }

        public void add_value(Serie serie, double value) {
            serie.add({GLib.get_real_time() / 1000, value});
            config.y_axis.update_bounds(value);
        }

        public void to_png(string filename) throws Error {
            var window = this.get_window();
            if (window == null) {
                throw new ChartError.EXPORT_ERROR("Chart is not realized yet");
            }
            var pixbuff = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
            pixbuff.savev(filename, "png", {}, {});
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

        private bool render(Gtk.Widget _, Context ctx) {
            
            config.configure(ctx, legend);

            ctx.select_font_face(Config.FONT_FACE, FontSlant.NORMAL, FontWeight.NORMAL);
            ctx.set_font_size(Config.FONT_SIZE);
            
            this.background.draw(ctx, config);
            this.grid.draw(ctx, config);
            if(this.legend != null) this.legend.draw(ctx, config);

            var boundaries = this.config.boundaries();
            foreach (Drawable serie in this.series) {
                ctx.rectangle(boundaries.x.min, boundaries.y.min, boundaries.x.max, boundaries.y.max);
                ctx.clip();
                serie.draw(ctx, this.config);
            }
            
            return true;
        }
    }
}