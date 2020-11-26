using Cairo;

namespace LiveChart { 

    public abstract class SerieRenderer : Drawable, Object {

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

    }
}