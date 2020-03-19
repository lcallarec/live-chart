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
        protected BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };

        public Values get_values() {
            return this.values;
        }

        public abstract void draw(Bounds bounds, Context ctx, Geometry geometry);
        public BoundingBox get_bounding_box() {
            return bounding_box;
        }
        protected Values values;
        
        protected void debug(Context ctx) {
            var debug = Environment.get_variable("LIVE_CHART_DEBUG");
            if(debug != null) {
                ctx.rectangle(bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height);
                ctx.stroke();
            }
        }
    }
}