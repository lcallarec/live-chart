using Cairo;

namespace LiveChart { 
    public interface Drawable : Object {
        public abstract void draw(Bounds bounds, Context ctx, Geometry geometry);
    }
}