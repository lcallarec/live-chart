using Cairo;

namespace LiveChart { 

    [Flags]
    public enum AutoPadding {
        TOP,
        RIGHT,
        BOTTOM,
        LEFT
    }

    public struct Padding {
        public AutoPadding? smart;
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

        public void reconfigure(Context ctx,Legend? legend) {
            // Not very scalable
            var max_value_displayed = (int) Math.round((this.height - this.padding.bottom - this.padding.top) / this.y_axis.get_ratio());
            TextExtents max_value_displayed_extents;
            ctx.text_extents(max_value_displayed.to_string() + y_axis.unit, out max_value_displayed_extents);
            
            var time_format_extents = abscissa_time_extents(ctx);

            if (AutoPadding.RIGHT in this.padding.smart) this.padding.right = 10 + (int) time_format_extents.width / 2;
            if (AutoPadding.LEFT in this.padding.smart) this.padding.left = 10 + (int) max_value_displayed_extents.width;
            if (AutoPadding.BOTTOM in this.padding.smart) this.padding.bottom = 15 + (int) time_format_extents.height;
            if (AutoPadding.TOP in this.padding.smart) this.padding.top = 10;
            
            if(legend != null && AutoPadding.BOTTOM in this.padding.smart) this.padding.bottom = this.padding.bottom + (int) legend.get_bounding_box().height + 5;
        }

        protected TextExtents abscissa_time_extents(Context ctx) {
            var time_format = "00:00:00";
            TextExtents time_extents;
            ctx.text_extents(time_format, out time_extents);

            return time_extents;
        }
    }
}