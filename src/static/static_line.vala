using Cairo;
using LiveChart;

namespace LiveChart.Static { 
    public class StaticLine : StaticSerieRenderer {

        public StaticLine(StaticValues values = new StaticValues()) {
            base();
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = StaticPoints.create(values, config);
                if (points.size > 0) {
                    this.draw_line(points, ctx, config);
                    ctx.stroke();
                }
            }
        }

        protected void draw_line(StaticPoints points, Context ctx, Config config) {
            line.configure(ctx);
            
            var first_point = points.first();

            this.update_bounding_box(points, config);
            this.debug(ctx);

            ctx.move_to(first_point.x, first_point.y);
            message("Draw point %f, %f".printf(first_point.x, first_point.y));
            for (int pos = 0; pos < points.size -1; pos++) {
                var current_point = points.get(pos);
                var next_point = points.after(pos);
                if (this.is_out_of_area(current_point)) {
                    message("#########################Out of area");
                    ctx.move_to(current_point.x, current_point.y);
                    continue;
                }
                message("Draw point %f, %f as pos %d".printf(next_point.x, next_point.y, pos));
                ctx.line_to(next_point.x, next_point.y);
            }
        }

        private void update_bounding_box(StaticPoints points, Config config) {
            this.bounding_box = BoundingBox() {
                x=points.first().x,
                y=points.bounds.lower,
                width=points.last().x - points.first().x,
                height=points.bounds.upper - points.bounds.lower
            };
        }
    }
}