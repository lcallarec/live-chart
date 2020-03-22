namespace LiveChart {

    public class Bounds {

        public double? lower {
            get; private set;
        }
        public double? upper {
            get; private set;
        }

        public Bounds(double? lower = null, double? upper = null) {
            this.lower = lower;
            this.upper = upper;
        }

        public bool update(double value) {
            var updated = false;
            if (lower == null) {
                lower = value;
                updated = true;
            }

            if (upper == null) {
                upper = value;
                updated = true;             
            }
            if (value < lower) {
                lower = value;
                updated = true;             
            }
            if (value > upper) {
                upper = value;
                updated = true;
            }
            return updated;
        }
    }
}