namespace LiveChart { 
    public class XAxis {

        public float tick_interval { get; set; default = 10;}
        public float tick_length { get; set; default = 60;}

        public double get_ratio() {
            return tick_length / tick_interval;
        }
    }

    public struct FixedBounds {
        double min;
        double max;
    }

    public class YAxis {
        private const double Y_RATIO_THRESHOLD = 1.218;
        private Bounds bounds = new Bounds();
        private double ratio = 1;

        public float tick_interval { get; set; default = 60;}
        public float tick_length { get; set; default = 60;}
        public string unit { get; set; default = "";}
        public bool smart_ratio = false;
        public double? fixed_max;
        public float max_displayed_value = 0f;
        
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

        public void update_ratio(int area_height, int height) {
            if (bounds.upper != null && this.fixed_max == null) {
                var ratio = this.bounds.upper * this.get_ratio_threshold() > area_height ? (double) (area_height) / this.bounds.upper / this.get_ratio_threshold() : 1;
                if(ratio > 0) {
                    this.ratio = ratio;
                    this.tick_length = (int) (this.tick_interval / ratio);
                }
            }
            
            if (this.fixed_max != null) {
                this.ratio = (double) area_height / ((double) this.fixed_max);
                this.tick_length = this.tick_interval;
            }
        }

        public double get_ratio_threshold() {
            if (this.fixed_max != null) {
                return 1;
            }

            return Y_RATIO_THRESHOLD;
        }
    }
}
