using Cairo;

namespace LiveChart { 
    public class SmoothLine : SerieRenderer {
        private SmoothLineDrawer drawer = new SmoothLineDrawer();
        public SmoothLine(Values values = new Values()) {
             this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = Points.create(values, config);
                if(points.size > 0) {
                    draw_smooth_line(points, ctx, config, line);
                    ctx.stroke();
                }            
            }
        }

        public void draw_smooth_line(Points points, Context ctx, Config config, Path line) {
            drawer.draw(points, ctx, config, line);
        }
    }

    public class SmoothLineDrawer : Object {
        public void draw(Points points, Context ctx, Config config, Path line) {
            line.configure(ctx);
            
            var first_point = points.first();
            ctx.move_to(first_point.x, first_point.y);
            for (int pos = 0; pos <= points.size -1; pos++) {
                var previous_point = points.get(pos);
                var target_point = points.after(pos);
                var pressure = (target_point.x - previous_point.x) / 2.0;

                if (is_out_of_area(previous_point)) {
                    continue;
                }

                ctx.curve_to(
                    previous_point.x + pressure, previous_point.y,
                    target_point.x - pressure, target_point.y, 
                    target_point.x, target_point.y
                );
            }
        }
        
        public BoundingBox get_bounding_box(Points points, Config config) {
            return BoundingBox() {
                x=points.first().x,
                y=points.bounds.lower,
                width=points.last().x - points.first().x,
                height=points.bounds.upper - points.bounds.lower
            };
        }
    }
}