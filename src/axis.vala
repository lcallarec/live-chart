namespace LiveChart { 
    public class XAxis {

        public int tick_interval { get; set; default = 10;}
        public int tick_length { get; set; default = 60;}

        public double get_ratio() {
            return tick_length / tick_interval;
        }
    }

    public class YAxis {
        private const double Y_RATIO_THRESHOLD = 1.218;
        private Bounds bounds = new Bounds();
        private double ratio = 1;

        public int tick_interval { get; set; default = 60;}
        public int tick_length { get; set; default = 60;}
        public string unit { get; set; default = "";}

        public YAxis(string unit = "") {
            this.unit = unit;
        }

        public double get_ratio() {
            return this.ratio;
        }

        public Bounds get_bounds() {
            return new Bounds(this.bounds.lower, this.bounds.upper);
        }

        public bool update_bounds(double value) {
            return this.bounds.update(value);
        }

        public void update_ratio(Boundaries boundaries, int height) {
            this.ratio = this.bounds.upper > (boundaries.height) / Y_RATIO_THRESHOLD ? (double) (boundaries.height) / this.bounds.upper / Y_RATIO_THRESHOLD : 1;
        }
    }
}
