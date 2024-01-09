using Cairo;

namespace LiveChart { 
    public struct BoundingBox {
        double x;
        double y;
        double width;
        double height;
    }
    public interface Drawable : Object {
        public abstract bool visible { get; set; default = true; }
        public abstract void draw(Context ctx, Config config);
    }

    //Hack needed for Serie compilation (get_main_color method and main_color property transpiled with same name
    //since main_color has been removed from Drawable interface
    public interface Colorable : Object {
        [Version (deprecated = true, deprecated_since = "1.8.0", replacement = "Serie.line.color")]
        public abstract Gdk.RGBA main_color { get; set; }
    }

    public abstract class Drawer {
        private const int VIRTUAL_LEFT_PADDING = -200;
        protected bool is_out_of_area(Point point) {
            return point.x < Drawer.VIRTUAL_LEFT_PADDING;
        }
    }
}