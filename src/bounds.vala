namespace LiveChart {

    public class Bounds {
        public signal void upper_bound_updated(double value);
        public signal void lower_bound_updated(double value);        

        public double? lower {
            get; private set;
        }
        public double? upper {
            get; private set;
        }

        public void update(double value) {
            if (lower == null) {
                lower = value;
                this.lower_bound_updated(value);  
            }

            if (upper == null) {
                upper = value;
                this.upper_bound_updated(value);
            }
            if (value < lower) {
                lower = value;
                this.lower_bound_updated(value);                
            }
            if (value > upper) {
                upper = value;
                this.upper_bound_updated(value);
            }
        }
    }
}