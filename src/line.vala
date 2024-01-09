using Cairo;

namespace LiveChart { 
    public class Line : SerieRenderer {

        private LineDrawer drawer = new LineDrawer();

        public Line(Values values = new Values()) {
            base();
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, this.line, Points.create(values, config));
                ctx.stroke();
            }
        }
    }

    public class LineDrawer : Drawer {
        public void draw(Context ctx, Config config, Path line, Points points) {
            if (points.size > 0) {

                line.configure(ctx);
                
                var first_point = points.first();

                ctx.move_to(first_point.x, first_point.y);
                for (int pos = 0; pos < points.size -1; pos++) {
                    var current_point = points.get(pos);
                    var next_point = points.after(pos);
                    if (this.is_out_of_area(current_point)) {
                        ctx.move_to(current_point.x, current_point.y);
                        continue;
                    }

                    ctx.line_to(next_point.x, next_point.y);
                }
            }
        }
    }
}