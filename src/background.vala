using Cairo;

namespace LiveChart { 
    public class Background: Drawable, Object {
        public Gdk.RGBA color { 
            get; set; default= Gdk.RGBA() {
                red = 0.1,
                green = 0.1,
                blue = 0.1,
                alpha = 1.0
            };
        }

        public void draw(Bounds bounds, Context ctx, Geometry geometry) {
            ctx.rectangle(0, 0, geometry.width, geometry.height);
            ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
            ctx.fill();
        }
    }
}