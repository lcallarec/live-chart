using Cairo;

namespace LiveChart { 
    public class Line : Drawable, Object {
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
        public Line(Values values) {
            this.values = values;
        }

        public void draw(Context ctx, Geometry geometry) {
           
            ctx.set_source_rgba(this.color.red, this.color.green, this.color.blue, this.color.alpha);
            ctx.set_line_width(this.width);
            
            var points = Points.create(values, geometry);
            var first_point = points.first();

            ctx.move_to(first_point.x, first_point.y);
            for (int pos = 1; pos <= points.size -1; pos++) {
                var current_point = points.get(pos);
                var next_point = points.after(pos);
                if (current_point.x < geometry.padding.left) {
                    ctx.move_to(current_point.x, current_point.y);
                    continue;
                }
                ctx.line_to(next_point.x, next_point.y);
            }
            
            ctx.stroke();
        }
    }
}