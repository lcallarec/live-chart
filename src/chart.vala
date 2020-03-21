using Cairo;

namespace LiveChart {

    public errordomain ChartError
    {
        EXPORT_ERROR
    }

    public class Chart : Gtk.DrawingArea {

        public Grid grid { get; set construct; }
        public Drawable background { get; public set; default = new Background(); } 
        public Legend legend { get; public set; } 
        
        private Config config;

        private Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();

        private Bounds bounds = new Bounds();

        public Chart(Config config = new Config()) {
            this.config = config;
            this.init_geometry();
            this.size_allocate.connect((allocation) => {
                this.config.height = allocation.height;
                this.config.width = allocation.width;
                
                this.config.y_axis.max_value = bounds.upper;
                this.config.y_axis.update_ratio(config.boundaries(), allocation.height);
            });

            this.bounds.upper_bound_updated.connect((value) => {
                this.config.y_axis.max_value = value;
                this.config.y_axis.update_ratio(config.boundaries(), this.get_allocated_height());
            });

            this.draw.connect(render);
            
            Timeout.add(100, () => {
                this.queue_draw();
                return true;
            });
        }

        public void add_serie(Serie serie) {
            this.series.add(serie);
            if(this.legend != null) this.legend.add_legend(serie);
        }

        public void add_value(Serie serie, double value) {
            serie.add({GLib.get_real_time() / 1000, value});
            bounds.update(value);
            this.queue_draw();
        }

        public void to_png(string filename) throws Error {
            var window = this.get_window();
            if (window == null) {
                throw new ChartError.EXPORT_ERROR("Chart is not realized yet");
            }
            var pixbuff = Gdk.pixbuf_get_from_window(window, 0, 0, window.get_width(), window.get_height());
            pixbuff.savev(filename, "png", {}, {});
        }

        private bool render(Gtk.Widget _, Context ctx) {
            ctx.select_font_face(Config.FONT_FACE, FontSlant.NORMAL, FontWeight.NORMAL);
            ctx.set_font_size(Config.FONT_SIZE);
            
            if (this.config.auto_padding) {
                this.config.reconfigure(ctx, grid, legend);
            }
            
            this.background.draw(bounds, ctx, config);
            this.grid.draw(bounds, ctx, config);
            if(this.legend != null) this.legend.draw(bounds, ctx, config);

            var boundaries = this.config.boundaries();
            foreach (Drawable serie in this.series) {
                ctx.rectangle(boundaries.x.min, boundaries.y.min, boundaries.x.max, boundaries.y.max);
                ctx.clip();
                serie.draw(bounds, ctx, this.config);
            }
            
            return true;
        }

        private void init_geometry() {
            config.height = this.get_allocated_height();
            config.width = this.get_allocated_width();
        }
    }
}