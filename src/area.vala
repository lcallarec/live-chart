   using Cairo;

   namespace LiveChart {
     public class Area : Drawable, Object {
        
        public bool visible { get; set; default = true; }

        private AreaDrawer drawer = new AreaDrawer();
        private Points points;
        private Gdk.RGBA color;

        private double alpha = 0.3;

        public Area(Points points, Gdk.RGBA color, double alpha) {
            this.points = points;
            this.color = color;
            this.alpha = alpha;
        }

        public void draw(Context ctx, Config config) {
           drawer.draw(ctx, config, this.points, this.color, this.alpha);
        }
    }

    public class AreaDrawer : Object {
        public void draw(Context ctx, Config config, Points points, Gdk.RGBA color, double alpha) {
            if (points.size > 0) {
                var boundaries = config.boundaries();
                var first_point = points.first();
                var last_point = points.last();

                ctx.set_source_rgba(color.red, color.green, color.blue, alpha);
                ctx.line_to(last_point.x, last_point.y);
                ctx.line_to(last_point.x, boundaries.y.max);
                ctx.line_to(first_point.x, boundaries.y.max);
                ctx.line_to(first_point.x, first_point.y);
                ctx.close_path();
            }
        }
    }
}
   