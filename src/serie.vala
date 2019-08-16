using Cairo;
using Gee;

namespace LiveChart {
    
    public class Serie : Object {

        private Gee.ArrayList<Point?> buffer = new Gee.ArrayList<Point?>();
        private const int MAX_BUFFER_SIZE = 10;
        private int64 time_start = new DateTime.now().to_unix();

        public string name { get; construct set;}
        public Line line { get; set; default = new Line(); }

        public Serie(string name) {
            this.name = name;
        }

        public void add(double value) {
            buffer.add({new DateTime.now().to_unix() - time_start, value});
        }

        public void render(Context ctx, Geometry geometry) {
            if (buffer.size == 0) return;
            
            ctx.set_source_rgba(this.line.color.red, this.line.color.green, this.line.color.blue, this.line.color.alpha);
            ctx.set_line_width(this.line.line_width);

            double current_x_pos = geometry.width - geometry.padding;
            for (int pos = buffer.size - 1; pos >= 0; pos--) {
                
                if (current_x_pos < geometry.padding) {
                    break;
                }
                var current_point = buffer[pos];
                var previous_point = pos == buffer.size - 1 ? current_point : buffer[pos + 1];

                ctx.move_to(current_x_pos, geometry.height - geometry.padding - (previous_point.y * geometry.y_ratio));

                current_x_pos = current_x_pos - (previous_point.x - current_point.x);

                ctx.line_to(current_x_pos, geometry.height  - geometry.padding - (current_point.y * geometry.y_ratio));
            }
            
            ctx.stroke();
        }
    }
}