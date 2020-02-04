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
    

    public struct Geometry {
        public int width;
        public int height;
        public Padding padding;
        public bool auto_padding;
        public double y_ratio;
        public Boundaries boundaries() {
            return Boundaries() {
               x = {padding.left, width - padding.right},
               y = {padding.top, height - padding.bottom}
            };
        }
        public Point translate(Point point) {
            return Point() {
                x = point.x,
                y = point.y * y_ratio
            };
        }
        
        public Geometry() {
            width = 0;
            height = 0;
            padding = Padding();
            auto_padding = false;
            y_ratio = 1.0;
        }
    }
}