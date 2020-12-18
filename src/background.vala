using Cairo;

namespace LiveChart { 

    public class Background : Drawable, Object {
        private BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        
        public bool visible { get; set; default = true; }

        public Gdk.RGBA color { 
            get {
                return main_color;
            }
            set {
                main_color = value;
            }
        }

        public LinearGradient? gradient { get; set; }

        [Version (deprecated = true, deprecated_since = "1.8.0", replacement = "Background.color")]
        public Gdk.RGBA main_color { 
            get; set; default= Gdk.RGBA() {
                red = 0.1,
                green = 0.1,
                blue = 0.1,
                alpha = 1.0
            };
        }

        public void draw(Context ctx, Config config) {
            if (visible) {
                this.update_bounding_box(config);
                ctx.rectangle(0, 0, config.width, config.height);
                if (gradient != null) {
                    GradientLine line = {
                        from : {config.width/2, 0},
                        to: { config.width/2, config.height}
                    };
                    new LinearGradientDrawer().draw(ctx, config, gradient, line);
                } else {
                    ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
                }
                ctx.fill();                
            }
        }

        public BoundingBox get_bounding_box() {
            return bounding_box;
        }

        private void update_bounding_box(Config config) {
            bounding_box = BoundingBox() {
                x=0, 
                y=0, 
                width=config.width,
                height=config.height
            };
        }
    }
}