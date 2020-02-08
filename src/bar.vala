using Cairo;

namespace LiveChart { 
    public class Bar : Drawable, Object {
        public Gdk.RGBA color { 
            get; set; default= Gdk.RGBA() {
                red = 1.0,
                green = 1.0,
                blue = 1.0,
                alpha = 1.0
            };
        }

        private Values values;
        public Bar(Values values) {
            this.values = values;
        }

        public void draw(Context ctx, Geometry geometry) {

            ctx.set_source_rgba(this.color.red, this.color.green, this.color.blue, this.color.alpha);
            var points = Points.create(values, geometry);
            for (int pos = 0; pos <= points.size -1; pos++) {
                var current_point = points.get(pos);
                var next_point = points.after(pos);

                if (current_point.x < geometry.padding.left) {
                    continue;
                }
                var bar_width = (current_point.x - next_point.x) / 1.2;
                ctx.rectangle(next_point.x, next_point.y, bar_width, next_point.height);
            }
              
            ctx.fill();
        }
    }
}