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

        public int width {
            get; set; default = 0;
        }

        public int height {
            get; set; default = 0;
        }

        public Padding padding = Padding();

        public YAxis y_axis = new YAxis();
        public XAxis x_axis = new XAxis();
        
        public TimeSeek time = new TimeSeek();
        
        internal Gee.ArrayList<string> categories;

        public Boundaries boundaries() {
            return Boundaries() {
               x = {min: padding.left, max: width - padding.right},
               y = {min: padding.top, max: height - padding.bottom},
               width =  width - padding.right - padding.left,
               height = height - padding.bottom - padding.top
            };
        }

        public void configure(Context ctx, Legend? legend) {
            configure_y_max_labels_extents(ctx);
            configure_x_max_labels_extents(ctx);

            if (AutoPadding.RIGHT in this.padding.smart) this.padding.right = 10 + (int) x_axis.labels.extents.width / 2;
            if (AutoPadding.LEFT in this.padding.smart) this.padding.left = (int) y_axis.labels.extents.width;
            if (AutoPadding.BOTTOM in this.padding.smart) this.padding.bottom = 15 + (int) x_axis.labels.extents.height;
            if (AutoPadding.TOP in this.padding.smart) this.padding.top = 10;
            
            if(legend != null && AutoPadding.BOTTOM in this.padding.smart) this.padding.bottom = this.padding.bottom + (int) legend.get_bounding_box().height + 5;
            
            this.y_axis.update(this.boundaries().height);
        }

        private void configure_y_max_labels_extents(Context ctx) {
            TextExtents extents;
            if (y_axis.visible && y_axis.labels.visible) {
                y_axis.labels.font.configure(ctx);
                //add two _ extra chars to get an aesthetic padding when y axis has no unit
                var spaces = y_axis.unit.length == 0 ? "__" : y_axis.unit;
                ctx.text_extents(y_axis.get_max_displayed_value() + spaces, out extents);
            } else {
                extents = TextExtents();
                extents.height = 0.0;
                extents.width = 0.0;
                extents.x_advance = 0.0;
                extents.x_bearing = 0.0;
                extents.y_advance = 0.0;
                extents.y_bearing  = 0.0;
            }
            
            y_axis.labels.extents = extents;
        }

        private void configure_x_max_labels_extents(Context ctx) {
            TextExtents extents;
            if (x_axis.visible && x_axis.labels.visible) {
                x_axis.labels.font.configure(ctx);
                var time_format = "00:00:00";
                ctx.text_extents(time_format, out extents);
            } else {
                extents = TextExtents();
                extents.height = 0.0;
                extents.width = 0.0;
                extents.x_advance = 0.0;
                extents.x_bearing = 0.0;
                extents.y_advance = 0.0;
                extents.y_bearing  = 0.0;
            }

            x_axis.labels.extents = extents;
        }
    }
}