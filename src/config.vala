using Cairo;

namespace LiveChart { 

    public struct Padding {
        public int top;
        public int right;
        public int bottom;
        public int left;

        public Padding() {
            top = 0;
            right = 0;
            bottom = 0;
            left = 0;
        }
    }

    public struct Boundary {
        public int min;
        public int max;
    }

    public struct Boundaries {
        public Boundary x;
        public Boundary y;
    }

    public class Config {

        public const int FONT_SIZE = 10;
        public const string FONT_FACE = "Sans serif";

        public int width {
            get; set; default = 0;
        }

        public int height {
            get; set; default = 0;
        }

        public Padding padding = Padding();

        public bool auto_padding {
            get; set; default = true;
        }

        public double y_ratio = 1.0;
        public XAxis x_axis = XAxis();

        private const double Y_RATIO_THRESHOLD = 1.218;

        public Boundaries boundaries() {
            return Boundaries() {
               x = {padding.left, width - padding.right},
               y = {padding.top, height - padding.bottom}
            };
        }

        public void update_yratio(double max_value, int height) {
            y_ratio = max_value > (height - padding.top - padding.bottom) / Y_RATIO_THRESHOLD ? (double) (height - padding.top - padding.bottom) / max_value / Y_RATIO_THRESHOLD : 1;
        }

        public Config recreate(Context ctx, Grid grid, Legend? legend) {
            // Not very scalable
            var max_value_displayed = (int) Math.round((this.height - this.padding.bottom - this.padding.top) / this.y_ratio);
            TextExtents max_value_displayed_extents;
            ctx.text_extents(max_value_displayed.to_string() + grid.unit, out max_value_displayed_extents);
            
            var time_format_extents = abscissa_time_extents(ctx);

            var new_geometry = new Config();
            new_geometry.height = this.height;
            new_geometry.width = this.width;
            new_geometry.padding = { 
                    10,
                    10 + (int) time_format_extents.width / 2,
                    15 + (int) time_format_extents.height,
                    10 + (int) max_value_displayed_extents.width, 
            };

            if(legend != null) new_geometry.padding.bottom = new_geometry.padding.bottom + (int) legend.get_bounding_box().height + 5;

            new_geometry.auto_padding = this.auto_padding;
            new_geometry.y_ratio = this.y_ratio;

            return new_geometry;
        }

        protected TextExtents abscissa_time_extents(Context ctx) {
            var time_format = "00:00:00";
            TextExtents time_extents;
            ctx.text_extents(time_format, out time_extents);

            return time_extents;
        }
    }
}