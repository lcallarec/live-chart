   using Cairo;

   namespace LiveChart {
     public class Area : Drawable, Object {
        private Points points;
        private Gdk.RGBA color;
        private BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        private double alpha = 0.3;
        public bool visible { get; set; default = true; }

        public Area(Points points, Gdk.RGBA color, double alpha) {
            this.points = points;
            this.color = color;
            this.alpha = alpha;
        }

        public void draw(Context ctx, Config config) {
            if (this.points.size > 0) {
                var boundaries = config.boundaries();
                var first_point = points.first();
                var last_point = points.last();

                ctx.set_source_rgba(this.color.red, this.color.green, this.color.blue, alpha);
                ctx.line_to(last_point.x, last_point.y);
                ctx.line_to(last_point.x, boundaries.y.max);
                ctx.line_to(first_point.x, boundaries.y.max);
                ctx.line_to(first_point.x, first_point.y);
                ctx.close_path();
            }
        }

        public BoundingBox get_bounding_box() {
            return bounding_box;
        }
    }
}
   