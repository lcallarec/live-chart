using Cairo;
namespace LiveChart { 

    public class Serie : DrawableSerie {

        public string name {
            get; set;
        }

        private DrawableSerie renderer;

        public Serie(string name, DrawableSerie renderer = new Line()) {
            this.name = name;
            this.renderer = renderer;
            this.notify["main-color"].connect(() => {
                 set_main_color(this.main_color);
            });
        }

        public override void draw(Context ctx, Config config) {
            this.renderer.draw(ctx, config);
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