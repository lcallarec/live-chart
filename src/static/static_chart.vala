using Cairo;
using LiveChart;

namespace LiveChart.Static {

     public class StaticChart : Gtk.DrawingArea {

        public StaticGrid grid { get; set; default = new StaticGrid(); }
        public Background background { get; set; default = new Background(); } 
        public Legend legend { get; set; default = new HorizontalLegend(); } 
        public Config config;
        public StaticSeries series;

        private Gee.ArrayList<string> categories = new Gee.ArrayList<string>();

        public StaticChart(Config config = new Config()) {
            this.config = config;
            this.size_allocate.connect((allocation) => {
                this.config.height = allocation.height;
                this.config.width = allocation.width;
            });

            this.draw.connect(render);
            
            series = new StaticSeries(this);
        }

        public void set_categories(Gee.ArrayList<string> categories) {
            this.categories = categories;
            config.categories = categories;
        }

        public void add_serie(StaticSerie serie) {
            this.series.register(serie);
            
        }

        private bool render(Gtk.Widget _, Context ctx) {
            
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
            
            return true;
        }
    }
}
