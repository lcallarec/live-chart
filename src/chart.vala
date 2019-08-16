using Cairo;

namespace LiveChart {

    public errordomain LiveChartError {
        SERIE_NOT_FOUND
    }

    public struct Limits {
        double min;
        double max;
    }

    public class Chart : Gtk.DrawingArea {

        public Grid grid { get; set; default = new Grid(); }
        public Geometry geometry;
        
        private const double RATIO_THRESHOLD = 1.218;

        private Background background { get; public set; default = new Background(); } 
        private Limits limits { get; set; default = Limits() {min = 0.0, max = 0.0};}

        private Gee.HashMap<string, Serie> series = new Gee.HashMap<string, Serie>();

        public Chart() {
            this.geometry = Geometry() {
                height = this.get_allocated_height(),
                width = this.get_allocated_width(),
                padding = { 30, 30, 30, 30 },
                y_ratio = ratio_from(this.get_allocated_height())
            };
            
            this.size_allocate.connect((allocation) => {
                this.geometry.height = allocation.height;
                this.geometry.width = allocation.width;
                this.geometry.y_ratio = ratio_from(allocation.height);
            });

            this.draw.connect(render);
        }

        public void serie(Serie serie) {
            this.series.set(serie.name, serie);
        }

        public void add_point(string serie_name, double value) throws LiveChartError  {
            var serie = this.series.get(serie_name);
            if (serie == null) {
                throw new LiveChartError.SERIE_NOT_FOUND("Can't add a new point to unknown serie %s".printf(serie_name));
            }

            if (value > this.limits.max) {
                this.limits = Limits() {min = this.limits.min, max = value};
                this.geometry.y_ratio = ratio_from(this.get_allocated_height());                
            }
            if (value < this.limits.min) this.limits = Limits() {min = value, max = this.limits.max};
            
            serie.add(value);
            this.queue_draw();
        }

        private bool render(Gtk.Widget _, Context ctx) {
            this.background.render(ctx, this.geometry);
            foreach (Serie serie in this.series.values) {
                serie.render(ctx, this.geometry);
            }
            
            this.grid.render(ctx, this.geometry);
            return true;
        }

        private double ratio_from(int height) {
            return this.limits.max > (height - this.geometry.padding.top - this.geometry.padding.bottom) / RATIO_THRESHOLD ? (double) (height - this.geometry.padding.top - this.geometry.padding.bottom) / this.limits.max / RATIO_THRESHOLD : 1;
        }
    }
}