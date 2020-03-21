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

    public struct YAxis {
        private const double Y_RATIO_THRESHOLD = 1.218;
        public int tick_interval;
        public int tick_length;

        public double max_value;
        public double min_value;

        public double ratio;

        public void update_ratio(Boundaries boundaries, int height) {
            this.ratio = max_value > (boundaries.height) / Y_RATIO_THRESHOLD ? (double) (boundaries.height) / max_value / Y_RATIO_THRESHOLD : 1;
        }

        public YAxis() {
            max_value = 0;
            min_value = 0;
            tick_length = 60;
            tick_length = 60;
            ratio = 1;
        }
    }
}
