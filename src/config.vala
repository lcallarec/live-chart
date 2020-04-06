using Cairo;

namespace LiveChart { 

    [Flags]
    public enum AutoPadding {
        NONE,
        TOP,
        RIGHT,
        BOTTOM,
        LEFT
    }

    public struct Padding {
        public AutoPadding smart;
        public int top;
        public int right;
        public int bottom;
        public int left;

        public Padding() {
            smart = AutoPadding.TOP | AutoPadding.RIGHT | AutoPadding.BOTTOM | AutoPadding.LEFT;
            top = 20;
            right = 20;
            bottom = 20;
            left = 20;
        }
    }

    public struct Boundary {
        public int min;
        public int max;
    }

    public struct Boundaries {
        public Boundary x;
        public Boundary y;
        public int width;
        public int height;
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

        public YAxis y_axis = new YAxis();
        public XAxis x_axis = new XAxis();

        public Boundaries boundaries() {
            return Boundaries() {
               x = {padding.left, width - padding.right},
               y = {padding.top, height - padding.bottom},
               width =  width - padding.right - padding.left,
               height = height - padding.bottom - padding.top
            };
        }

        public void configure(Context ctx, Legend? legend) {
            var max_value_extents = ordinate_value_extents(ctx);
            var time_format_extents = abscissa_time_extents(ctx);

            if (AutoPadding.RIGHT in this.padding.smart) this.padding.right = 10 + (int) time_format_extents.width / 2;
            if (AutoPadding.LEFT in this.padding.smart) this.padding.left = 10 + (int) max_value_extents.width;
            if (AutoPadding.BOTTOM in this.padding.smart) this.padding.bottom = 15 + (int) time_format_extents.height;
            if (AutoPadding.TOP in this.padding.smart) this.padding.top = 10;
            
            if(legend != null && AutoPadding.BOTTOM in this.padding.smart) this.padding.bottom = this.padding.bottom + (int) legend.get_bounding_box().height + 5;
            
            this.y_axis.update(this.boundaries().height);
        }

        private TextExtents ordinate_value_extents(Context ctx) {
            TextExtents max_value_extents;
            if (x_axis.labels.visible) {
                ctx.text_extents(y_axis.get_max_displayed_value(), out max_value_extents);
            } else {
                max_value_extents = TextExtents();
                max_value_extents.height = 0.0;
                max_value_extents.width = 0.0;
                max_value_extents.x_advance = 0.0;
                max_value_extents.x_bearing = 0.0;
                max_value_extents.y_advance = 0.0;
                max_value_extents.y_bearing  = 0.0;
            }

            return max_value_extents;
        }

        private TextExtents abscissa_time_extents(Context ctx) {
            TextExtents time_extents;
            if (x_axis.labels.visible) {
                var time_format = "00:00:00";
                ctx.text_extents(time_format, out time_extents);
            } else {
                time_extents = TextExtents();
                time_extents.height = 0.0;
                time_extents.width = 0.0;
                time_extents.x_advance = 0.0;
                time_extents.x_bearing = 0.0;
                time_extents.y_advance = 0.0;
                time_extents.y_bearing  = 0.0;
            }

            return time_extents;
        }
    }
}