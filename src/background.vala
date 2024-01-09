using Cairo;

namespace LiveChart { 
    public class Background : Drawable, Object {
        private BackgroundDrawer drawer = new BackgroundDrawer();
        
        public bool visible { get; set; default = true; }

        public Gdk.RGBA color { 
            get {
                return main_color;
            }
            set {
                main_color = value;
            }
        }

        [Version (deprecated = true, deprecated_since = "1.8.0", replacement = "Background.color")]
        public Gdk.RGBA main_color { 
            get; set; default = Gdk.RGBA() {
                red = 0.1f,
                green = 0.1f,
                blue = 0.1f,
                alpha = 1.0f
            };
        }

        public void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, this.color);
            }
        }
    }

    public class BackgroundDrawer : Object {
        public void draw(Context ctx, Config config, Gdk.RGBA color) {
            ctx.rectangle(0, 0, config.width, config.height);
            ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
            ctx.fill();
        }
    }
}