namespace LiveChart { 
    public struct Geometry {
        public int width;
        public int height;
        public int padding;
        public double y_ratio;
        
        public Geometry() {
            width = 0;
            height = 0;
            padding = 0;
            y_ratio = 1.0;
        }
    }
}