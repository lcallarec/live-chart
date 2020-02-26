using Cairo;

namespace LiveChart { 
    public class Curve : Drawable, Object {
        public Gdk.RGBA color { 
            get; set; default= Gdk.RGBA() {
                red = 1.0,
                green = 1.0,
                blue = 1.0,
                alpha = 1.0
            };
        }

        public double width { get; set; default = 1;}

        private Values values;
        public Curve(Values values) {
            this.values = values;
        }

        public void draw(Bounds bounds, Context ctx, Geometry geometry) {
            ctx.set_source_rgba(this.color.red, this.color.green, this.color.blue, this.color.alpha);
            ctx.set_line_width(this.width);
            
            var points = Points.create(values, geometry);
            var first_point = points.first();

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
    }
}