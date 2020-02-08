using Cairo;

namespace LiveChart {

    public struct Limits {
        double min;
        double max;
    }

    public class Chart : Gtk.DrawingArea {

        public Grid grid { get; set; default = new Grid(); }
        public Drawable background { get; public set; default = new Background(); } 
        
        private Geometry geometry;
        private const double RATIO_THRESHOLD = 1.218;
        private const int FONT_SIZE = 10;
        private const string FONT_FACE = "Sans serif";

        private Gee.ArrayList<Drawable> series = new Gee.ArrayList<Drawable>();

        private Limits limits { get; set; default = Limits() {min = 0.0, max = 0.0};}

        public Chart(Geometry geometry, string unit = "") {
            this.geometry = geometry;
            this.geometry.y_ratio = ratio_from(this.get_allocated_height());

            this.size_allocate.connect((allocation) => {
                this.geometry.height = allocation.height;
                this.geometry.width = allocation.width;
                this.geometry.y_ratio = ratio_from(allocation.height);
            });

            this.draw.connect(render);
        }

        public void add_serie(Drawable serie) {
            this.series.add(serie);
        }

        public void add_point(Points points, double value) {
            if (value > this.limits.max) {
                this.limits = Limits() {min = this.limits.min, max = value};
                this.geometry.y_ratio = ratio_from(this.get_allocated_height());                
            }
            if (value < this.limits.min) this.limits = Limits() {min = value, max = this.limits.max};
            
            points.add({new DateTime.now().to_unix(), value});
            this.queue_draw();
        }

        private bool render(Gtk.Widget _, Context ctx) {
            ctx.select_font_face(FONT_FACE, FontSlant.NORMAL, FontWeight.NORMAL);
            ctx.set_font_size(FONT_SIZE);
            
            Geometry geometry = this.geometry;
            if (this.geometry.auto_padding) {
                geometry = this.compute_new_geometry(ctx, geometry);
            }
            
            this.background.draw(ctx, geometry);
            this.grid.draw(ctx, geometry);
            foreach (Drawable serie in this.series) {
                serie.draw(ctx, geometry);
            }
            
            return true;
        }

        private Geometry compute_new_geometry(Context ctx, Geometry geometry) {
            var max_value_displayed = (int) Math.round((geometry.height - geometry.padding.bottom - geometry.padding.top) / geometry.y_ratio);
            var time_displayed = "00:00:00";

            TextExtents max_value_displayed_extents;
            TextExtents time_displayed_extents;            
            ctx.text_extents(max_value_displayed.to_string() + this.grid.unit, out max_value_displayed_extents);
            ctx.text_extents(time_displayed, out time_displayed_extents);
            
            return Geometry() {
                height = geometry.height,
                width = geometry.width,
                padding = { 
                    10,
                    10 + (int) time_displayed_extents.width / 2,
                    15 + (int) max_value_displayed_extents.height,
                    10 + (int) max_value_displayed_extents.width, 
                },
                auto_padding = geometry.auto_padding,
                y_ratio = geometry.y_ratio
            };
        }

        private double ratio_from(int height) {
            return this.limits.max > (height - this.geometry.padding.top - this.geometry.padding.bottom) / RATIO_THRESHOLD ? (double) (height - this.geometry.padding.top - this.geometry.padding.bottom) / this.limits.max / RATIO_THRESHOLD : 1;
        }
    }
}