using Cairo;

namespace LiveChart { 
    public struct BoundingBox {
        double x;
        double y;
        double width;
        double height;
    }
    public interface Drawable : Object {
        public abstract void draw(Bounds bounds, Context ctx, Geometry geometry);
        public abstract BoundingBox get_bounding_box();
    }
}