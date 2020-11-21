using Cairo;
namespace LiveChart { 

    public class Serie : Colorable, Drawable, Object {

        public string name {
            get; set;
        }
        
        public Gdk.RGBA main_color {
            get {
                return renderer.line.color;
            }

            set {
                renderer.line.color = value;
            }
        }
        
        public Path line {
            get {
                return renderer.line;
            }

            set {
                renderer.line = value;
            }
        }

        public bool visible { get; set; default = true; }

        public signal void value_added(double value);

        private SerieRenderer renderer;

        public Serie(string name, SerieRenderer renderer = new Line()) {
            this.name = name;
            this.renderer = renderer;
        }

        public void draw(Context ctx, Config config) {
            if (visible) {
                renderer.draw(ctx, config);
            }
        }

        public void add(double value) {
            renderer.get_values().add({GLib.get_real_time() / 1000, value});
            value_added(value);
        }

        public void add_with_timestamp(double value, int64 timestamp) {
            renderer.get_values().add({timestamp, value});
            value_added(value);
        }

        [Version (deprecated = true, deprecated_since = "1.7.1", replacement = "Serie.main_color property instead")]        
        public void set_main_color(Gdk.RGBA color) {
            main_color = color;
        }

        [Version (deprecated = true, deprecated_since = "1.7.1", replacement = "Serie.main_color property instead")]        
        public Gdk.RGBA get_main_color() {
            return main_color;
        }

        public Values get_values() {
            return renderer.get_values();
        }

        public void clear() {
            renderer.get_values().clear();
        }

        public BoundingBox get_bounding_box() {
            return renderer.get_bounding_box();
        }
    }
}