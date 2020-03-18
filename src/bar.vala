using Cairo;

namespace LiveChart { 
    public class Bar : DrawableSerie {

        public Bar(Values values) {
            this.values = values;
        }

        public override void draw(Bounds bounds, Context ctx, Geometry geometry) {

            ctx.set_source_rgba(this.main_color.red, this.main_color.green, this.main_color.blue, this.main_color.alpha);
            ctx.set_line_width(this.outline_width);

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