using Cairo;

namespace LiveChart {
    public struct BoundingBox {
        double x;
        double y;
        double width;
        double height;
    }
        
    public class Debug {
        public static void debug(Context ctx, BoundingBox bounding_box) {
            var debug = Environment.get_variable("LIVE_CHART_DEBUG");
            if(debug != null) {
                ctx.rectangle(bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height);
                ctx.stroke();
            }
        }
        public static void boundaries(Boundaries boundaries) {
            message("BOUNDARIES = x.min: %f, x.max: %f, y.min: %f, y.max: %f", boundaries.x.min, boundaries.x.max, boundaries.y.min, boundaries.y.max);
        }
        
        public static void config_geometry(Config config) {
            message("CONFIG = width: %f, height: %f, padding.left: %f, padding.right: %f", config.width, config.height, config.padding.left, config.padding.right);
        }
    }
}