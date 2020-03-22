using Cairo;

namespace LiveChart { 
    public class SmoothLine : DrawableSerie {

        public SmoothLine(Values values = new Values()) {
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            ctx.set_source_rgba(this.main_color.red, this.main_color.green, this.main_color.blue, this.main_color.alpha);
            ctx.set_line_width(this.outline_width);
            
            var points = Points.create(values, config);
            var first_point = points.first();
            
            this.update_bounding_box(points, config);
            this.debug(ctx);

            ctx.move_to(first_point.x, first_point.y);
            for (int pos = 0; pos <= points.size -1; pos++) {
                var previous_point = points.get(pos);
                var target_point = points.after(pos);
                var pressure = (target_point.x - previous_point.x) / 2.0;

                if (previous_point.x < config.padding.left) {
                    continue;
                }

                ctx.curve_to(
                    previous_point.x + pressure, previous_point.y,
                    target_point.x - pressure, target_point.y, 
                    target_point.x, target_point.y
                );
            }
            
            ctx.stroke();
        }

        private void update_bounding_box(Points points, Config config) {
            this.bounding_box = BoundingBox() {
                x=points.first().x,
                y=points.bounds.lower,
                width=points.last().x - points.first().x,
                height=points.bounds.upper - points.bounds.lower
            };
        }
    }
}