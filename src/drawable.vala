using Cairo;

namespace LiveChart { 
    public struct BoundingBox {
        double x;
        double y;
        double width;
        double height;
    }
    public interface Drawable : Object {
        public abstract Gdk.RGBA main_color { get; set; }
        public abstract void draw(Context ctx, Config config);
        public abstract BoundingBox get_bounding_box();
    }
}