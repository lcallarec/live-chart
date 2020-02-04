using Cairo;

namespace LiveChart { 
    public interface Drawable : Object {
        public abstract void draw(Context ctx, Geometry geometry);
    }
}