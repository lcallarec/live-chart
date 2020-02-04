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

        private Points points;
        public Line(Points points) {
            this.points = points;
        }

        public void draw(Context ctx, Geometry geometry) {
            Boundaries boundaries = geometry.boundaries();

            ctx.set_source_rgba(this.color.red, this.color.green, this.color.blue, this.color.alpha);
            ctx.set_line_width(this.width);

            double current_x_pos = boundaries.x.max;
            for (int pos = this.points.size - 1; pos >= 0; pos--) {
                
                if (current_x_pos < geometry.padding.left) {
                    break;
                }
                var current_point = this.points[pos];
                var previous_point = pos == this.points.size - 1 ? current_point : this.points.get(pos + 1);

                ctx.move_to(current_x_pos, boundaries.y.max - (previous_point.y * geometry.y_ratio));

                current_x_pos = current_x_pos - (previous_point.x - current_point.x);

                ctx.line_to(current_x_pos, boundaries.y.max - (current_point.y * geometry.y_ratio));
            }
            
            ctx.stroke();
        }
    }
}