   using Cairo;

   namespace LiveChart {
     public class Area : Drawable, Object {
        private Points points;
        private Gdk.RGBA color;
        private LinearGradient? gradient;
        private BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        private double alpha = 0.3;
        public bool visible { get; set; default = true; }

        public Area(Points points, Gdk.RGBA color, double alpha, LinearGradient? gradient) {
            this.points = points;
            this.color = color;
            this.alpha = alpha;
            this.gradient = gradient;
        }

        public void draw(Context ctx, Config config) {

            if (this.points.size > 0) {
                var boundaries = config.boundaries();
                var first_point = points.first();
                var last_point = points.last();

                if (gradient != null) {
                    Cairo.Pattern pattern = new Cairo.Pattern.linear(config.width/2, 0, config.width/2, config.height);
                    pattern.add_color_stop_rgba(0, gradient.from.red, gradient.from.green, gradient.from.blue, gradient.from.alpha);
                    pattern.add_color_stop_rgba(1, gradient.to.red, gradient.to.green, gradient.to.blue, gradient.to.alpha);
                    ctx.set_source(pattern);
                } else {
                    ctx.set_source_rgba(color.red, color.green, color.blue, alpha);
                }

                ctx.line_to(last_point.x, last_point.y);
                ctx.line_to(last_point.x, boundaries.y.max);
                ctx.line_to(first_point.x, boundaries.y.max);
                ctx.line_to(first_point.x, first_point.y);
                ctx.close_path();
                ctx.fill_preserve();
            }
  
        }
        public BoundingBox get_bounding_box() {
            return bounding_box;
        }
    }
}
   