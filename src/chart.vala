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
        
        private Config config;

        private Gee.ArrayList<Serie> series = new Gee.ArrayList<Serie>();

        public Chart(Config config = new Config()) {
            this.config = config;
            this.size_allocate.connect((allocation) => {
                this.config.height = allocation.height;
                this.config.width = allocation.width;
                this.config.y_axis.update_ratio(config.boundaries().height, allocation.height);
            });
            this.realize.connect(() => {
                this.config.y_axis.update_ratio(config.boundaries().height, this.get_allocated_height());
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
            if ((config.y_axis.update_bounds(value) && config.y_axis.smart_ratio)) {
                this.config.y_axis.update_ratio(config.boundaries().height, this.get_allocated_height());
            } 
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
            
            this.config.reconfigure(ctx, legend);

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