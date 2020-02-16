namespace LiveChart {

    public class Limits {
        public double min {
            get; private set; default = 0.0;
        }
        public double max {
            get; private set; default = 0.0;
        }

        public void update(double value) {
            if (value < min) min = value;
            if (value > max) max = value;
        }
    }
}