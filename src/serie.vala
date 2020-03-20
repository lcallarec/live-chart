using Cairo;
namespace LiveChart { 

    public class Serie : DrawableSerie {

        public string name {
            get; construct set;
        }

        private DrawableSerie renderer;

        public Serie(string name, DrawableSerie renderer) {
            this.name = name;
            this.renderer = renderer;
        }

        public override void draw(Bounds bounds, Context ctx, Geometry geometry) {
            this.renderer.draw(bounds, ctx, geometry);
        }

        public void add(TimestampedValue value) {
            this.renderer.get_values().add(value);
        }

        public void set_main_color(Gdk.RGBA color) {
            this.renderer.main_color = color;
        }

        public Gdk.RGBA get_main_color() {
            return this.renderer.main_color;
        }
    }
}