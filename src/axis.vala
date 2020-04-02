namespace LiveChart { 
    public class XAxis {

        public float tick_interval { get; set; default = 10;}
        public float tick_length { get; set; default = 60;}

        public double get_ratio() {
            return tick_length / tick_interval;
        }
    }

    public struct Ticks {
        Gee.List<float?> values;
        public Ticks() {
            values = new Gee.ArrayList<float?>();
        }
    }

    public class YAxis {
        private Bounds bounds = new Bounds();
        private double ratio = 1;
        
        public float ratio_threshold { get; set; default = 1.118f;}
        public float tick_interval { get; set; default = 60;}

        [Version (deprecated = true, deprecated_since = "1.0.0b7")]        
        public float tick_length { get; set; default = 60;}
        public string unit { get; set; default = "";}

        [Version (deprecated = true, deprecated_since = "1.0.0b7", replacement = "ratio is always smart ;)")]
        public bool smart_ratio = false;

        public double? fixed_max;
        public Gee.List<string> displayed_values { get; set; default = new Gee.LinkedList<string>();}
        public Ticks ticks;

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

        public void update(int area_height) {
            if (bounds.upper != null && this.fixed_max == null) {
                  this.ratio = (double) area_height / ((double) bounds.upper * ratio_threshold);
            }
            
            if (this.fixed_max != null) {
                this.ratio = (double) area_height / ((double) this.fixed_max);
            }

            this.ticks = get_ticks();
        }

        public string get_max_displayed_values() {
            if (displayed_values.size > 0) {
                string max_displayed_value = displayed_values.first();
                foreach(string value in displayed_values) {
                    if (value.length >= max_displayed_value.length) {
                        max_displayed_value = value;
                    }
                }
                return max_displayed_value;
            }

            return unit;
        }

        public Ticks get_ticks() {
            var ticks = Ticks();
            if (fixed_max != null) {
                for (var value = 0f; value <= fixed_max; value += tick_interval) {
                    ticks.values.add(value);
                }

                return ticks;
            }

            if (bounds.upper != null && fixed_max == null) {
                var upper = LiveChart.cap((float) bounds.upper);
                var divs = LiveChart.golden_divisors((float) upper);
             
                float interval = (float) upper / divs.get(0);
                foreach(var div in divs) {
                    interval = upper / div;
                    if (upper / interval > 3 && upper / interval < 7) {
                        break;
                    }
                }
                var limit = bounds.upper == upper ? upper : bounds.upper + interval;
                for (var value = 0f; value <= limit; value += interval) {
                    ticks.values.add(value);
                }
            }

            return ticks;
        }
    }
}
