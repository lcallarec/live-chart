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

    public class Geometry {

        public int width {
            get; set; default = 0;
        }

        public int height {
            get; set; default = 0;
        }

        public Padding padding = Padding();

        public bool auto_padding {
            get; set; default = false;
        }

        public double y_ratio = 1.0;

        private const double RATIO_THRESHOLD = 1.218;

        public Boundaries boundaries() {
            return Boundaries() {
               x = {padding.left, width - padding.right},
               y = {padding.top, height - padding.bottom}
            };
        }

        public void update_yratio(double max_value, int height) {
            y_ratio = max_value > (height - padding.top - padding.bottom) / RATIO_THRESHOLD ? (double) (height - padding.top - padding.bottom) / max_value / RATIO_THRESHOLD : 1;
        }
    }
}