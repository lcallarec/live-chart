using Cairo;

namespace LiveChart { 
    public class Curve : DrawableSerie {

        public Curve(Values values = new Values()) {
            this.values = values;
        }

        public override void draw(Bounds bounds, Context ctx, Geometry geometry) {
            ctx.set_source_rgba(this.main_color.red, this.main_color.green, this.main_color.blue, this.main_color.alpha);
            ctx.set_line_width(this.outline_width);
            
            var points = Points.create(values, geometry);
            var first_point = points.first();
            
            this.update_bounding_box(points, geometry);
            this.debug(ctx);
            ctx.move_to(first_point.x, first_point.y);
            for (int pos = 1; pos <= points.size -1; pos = pos + 3) {
                var start_point = points.get(pos);
                var middle_point = points.after(pos);
                var end_point = points.after(pos + 1);
                if (start_point.x < geometry.padding.left) {
                    continue;
                }
                ctx.curve_to(start_point.x + (middle_point.x - start_point.x) * 0.5f, start_point.y, start_point.x + (middle_point.x - start_point.x) * 0.5f, middle_point.y, end_point.x, end_point.y);
            }
            
            ctx.stroke();
        }

        private void update_bounding_box(Points points, Geometry geometry) {
            this.bounding_box = BoundingBox() {
                x=points.first().x,
                y=points.bounds.lower,
                width=points.last().x - points.first().x,
                height=points.bounds.upper - points.bounds.lower
            };
        }
    }
}