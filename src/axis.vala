namespace LiveChart { 
    public struct XAxis {

        public int tick_interval;
        public int tick_length;

        public double ratio() {
            return tick_length / tick_interval;
        }

        public XAxis() {
            tick_interval = 10;
            tick_length = 60;
        }
    }
}