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

    public struct Geometry {
        public int width;
        public int height;
        public Padding padding;
        public double y_ratio;
        
        public Geometry() {
            width = 0;
            height = 0;
            padding = Padding();
            y_ratio = 1.0;
        }
    }
}