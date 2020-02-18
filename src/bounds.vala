namespace LiveChart {

    public class Bounds {
        public signal void upper_bound_updated(Value value);
        public signal void lower_bound_updated(Value value);        

        public double lower {
            get; private set; default = 0.0;
        }
        public double upper {
            get; private set; default = 0.0;
        }

        public void update(double value) {
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