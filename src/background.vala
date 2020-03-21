using Cairo;

namespace LiveChart { 
    public class Background : Drawable, Object {
        private BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        public Gdk.RGBA color { 
            get; set; default= Gdk.RGBA() {
                red = 0.1,
                green = 0.1,
                blue = 0.1,
                alpha = 1.0
            };
        }

        public void draw(Bounds bounds, Context ctx, Config config) {
            this.update_bounding_box(config);
            ctx.rectangle(0, 0, config.width, config.height);
            ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
            ctx.fill();
        }

        public BoundingBox get_bounding_box() {
            return bounding_box;
        }

        private void update_bounding_box(Config config) {
            this.bounding_box = BoundingBox() {
                x=0, 
                y=0, 
                width=config.width,
                height=config.height
            };
        }
    }
}