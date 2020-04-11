using Cairo;
namespace LiveChart { 

    public class Serie : Drawable, Object {

        public string name {
            get; set;
        }
        public Gdk.RGBA main_color {
            get {
                return renderer.main_color;
            }

            set {
                renderer.main_color = value;
            }
        }
        
        public bool visible { get; set; default = true; }

        private DrawableSerie renderer;

        public Serie(string name, DrawableSerie renderer = new Line()) {
            this.name = name;
            this.renderer = renderer;
            this.notify["main-color"].connect(() => {
                 set_main_color(main_color);
            });
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                renderer.draw(ctx, config);
            }
        }

        public void add(TimestampedValue value) {
            renderer.get_values().add(value);
        }

        public void set_main_color(Gdk.RGBA color) {
            renderer.main_color = color;
        }

        public Gdk.RGBA get_main_color() {
            return renderer.main_color;
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