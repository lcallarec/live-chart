using Cairo;

namespace LiveChart { 

    public abstract class SerieRenderer : Drawable, Object {

        private const int VIRTUAL_LEFT_PADDING = -200;
        
        public bool visible { get; set; default = true; }
        
        [Version (deprecated = true, deprecated_since = "1.8.0", replacement = "Serie.renderer.line.color")]
        public Gdk.RGBA main_color {
            get {
                return line.color;
            }

            set {
                line.color = value;
            }
        }
        public Path line { get; set; }

        protected SerieRenderer() {
            line = new Path(1);
        }


        protected Values values;
        public Values get_values() {
            return this.values;
        }

        public abstract void draw(Context ctx, Config config);

        public static bool is_out_of_area(Point point) {
            return point.x < SerieRenderer.VIRTUAL_LEFT_PADDING;
        }
    }
}