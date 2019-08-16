using Cairo;

namespace LiveChart { 
    public class Line : Object {
        public Gdk.RGBA color { 
            get; set; default= Gdk.RGBA() {
                red = 1.0,
                green = 1.0,
                blue = 1.0,
                alpha = 1.0
            };
        }

        public double width { get; set; default = 1;}

        public void render(Context ctx, Geometry geometry, Gee.ArrayList<Point?> buffer) {
                
            ctx.set_source_rgba(this.color.red, this.color.green, this.color.blue, this.color.alpha);
            ctx.set_line_width(this.width);

            double current_x_pos = geometry.width - geometry.padding.right;
            for (int pos = buffer.size - 1; pos >= 0; pos--) {
                
                if (current_x_pos < geometry.padding.left) {
                    break;
                }
                var current_point = buffer[pos];
                var previous_point = pos == buffer.size - 1 ? current_point : buffer[pos + 1];

                ctx.move_to(current_x_pos, geometry.height - geometry.padding.bottom - (previous_point.y * geometry.y_ratio));

                current_x_pos = current_x_pos - (previous_point.x - current_point.x);

                ctx.line_to(current_x_pos, geometry.height  - geometry.padding.bottom - (current_point.y * geometry.y_ratio));
            }
            
            ctx.stroke();
        }
    }
}