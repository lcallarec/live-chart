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

        protected BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        
        protected Values values;
        public Values get_values() {
            return this.values;
        }

        public abstract void draw(Context ctx, Config config);

        public BoundingBox get_bounding_box() {
            return bounding_box;
        }
        
        protected void debug(Context ctx) {
            var debug = Environment.get_variable("LIVE_CHART_DEBUG");
            if(debug != null) {
                ctx.rectangle(bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height);
                ctx.stroke();
            }
        }

        protected bool is_out_of_area(Point point) {
            return point.x < SerieRenderer.VIRTUAL_LEFT_PADDING;
        }
    }
}