using Cairo;

namespace LiveChart { 
    public interface SerieRenderer : Object {
        public abstract void render(Context ctx, Geometry geometry, Gee.ArrayList<Point?> data);
    }
}