using Cairo;

namespace LiveChart { 
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
}