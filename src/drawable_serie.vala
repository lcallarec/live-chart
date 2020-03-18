using Cairo;

namespace LiveChart { 
    public abstract class DrawableSerie : Drawable, Object {
        public Gdk.RGBA main_color { 
            get; set; default= Gdk.RGBA() {
                red = 1.0,
                green = 1.0,
                blue = 1.0,
                alpha = 1.0
            };
        }
        public double outline_width { get; set; default = 1;}
        
        public Values get_values() {
            return this.values;
        }

        public abstract void draw(Bounds bounds, Context ctx, Geometry geometry);

        protected Values values;
    }
}