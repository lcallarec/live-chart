using Cairo;
using LiveChart;

namespace LiveChart.Static { 

    public class StaticSerie : Colorable, Drawable, Object {

        public string name {
            get; set;
        }
        
        public Gdk.RGBA main_color {
            get {
                return renderer.line.color;
            }

            set {
                renderer.line.color = value;
            }
        }
        public Path line {
            get {
                return renderer.line;
            }

            set {
                renderer.line = value;
            }
        }

        public bool visible { get; set; default = true; }

        public signal void value_added(double value);

        private StaticSerieRenderer renderer;

        public StaticSerie(string name, StaticSerieRenderer renderer = new StaticLine()) {
            this.name = name;
            this.renderer = renderer;
        }

        public void draw(Context ctx, Config config) {
            if (visible) {
                renderer.draw(ctx, config);
            }
        }

        public void add(string name, double value) {
            renderer.get_values().add({name, value});
            value_added(value);
        }

        public StaticValues get_values() {
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