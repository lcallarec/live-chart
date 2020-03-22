using Cairo;

namespace LiveChart { 
    public class Line : DrawableSerie {

        public Line(Values values = new Values()) {
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
            for (int pos = 1; pos <= points.size -1; pos++) {
                var current_point = points.get(pos);
                var next_point = points.after(pos);
                if (this.is_out_of_area(current_point)) {
                    ctx.move_to(current_point.x, current_point.y);
                    continue;
                }
                ctx.line_to(next_point.x, next_point.y);
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