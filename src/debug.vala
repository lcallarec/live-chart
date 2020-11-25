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
    }
}