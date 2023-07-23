using Cairo;
using LiveChart;

namespace LiveChart.Static {

     public class StaticChart : Gtk.DrawingArea {
        private Cairo.Context? m_context = null;

        public StaticGrid grid { get; set; default = new StaticGrid(); }
        public Background background { get; set; default = new Background(); } 
        public Legend legend { get; set; default = new HorizontalLegend(); } 
        public Config config;
        public StaticSeries series;

        private Gee.ArrayList<string> categories = new Gee.ArrayList<string>();

        public StaticChart(Config config = new Config()) {
            this.config = config;
            this.resize.connect((width, height) => {
                this.config.height = height;
                this.config.width = width;
            });

            this.set_draw_func(render);
            
            series = new StaticSeries(this);
        }

        public void set_categories(Gee.ArrayList<string> categories) {
            this.categories = categories;
            config.categories = categories;
        }

        public void add_serie(StaticSerie serie) {
            this.series.register(serie);
            
        }

        public void to_png(string filename) throws Error {
            GLib.return_if_fail(null != m_context);

            var surface = m_context.get_target();
            surface.write_to_png(filename);
        }

        private void render(Gtk.Widget drawing_area, Context ctx, int width, int height) {
            m_context = ctx;
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
