using Gee;

namespace LiveChart {
    
    public class Points : Object {

        private Gee.ArrayList<Point?> points = new Gee.ArrayList<Point?>();
        public Bounds bounds {
            get; construct set;
        }

        public Points() {
            this.bounds = new Bounds();
        }

        public void add(Point point) {
            bounds.update(point.y);
            points.add(point);
        }

        public int size {
            get {
                return points.size;
            }
        }

        public double realtime_delta {
            get; set;
        }

        public new Point get(int at) {
            return points.get(at);
        }

        public Point after(int at) {
            if (at + 1 >= size) return this.get(size - 1);
            return this.get(at + 1);
        }

        public Point first() {
            return this.get(0);
        }

        public Point last() {
            return this.get(this.size - 1);
        }

        public static Points create(Values values, Geometry geometry) {
            var boundaries = geometry.boundaries();

            Points points = new Points();
            var last_value = values.last();
            points.realtime_delta = (((GLib.get_real_time() / 1000) - last_value.timestamp) * geometry.x_ratio) / 1000;

            foreach (TimestampedValue value in values) {
                var point = Points.value_to_point(last_value, value, geometry, boundaries, points.realtime_delta);
                points.add(point);
            }

            return points;
        }

        private static Point value_to_point(TimestampedValue last_value, TimestampedValue current_value, Geometry geometry, Boundaries boundaries, double realtime_delta) {
            return Point() {
                x = (boundaries.x.max - (last_value.timestamp - current_value.timestamp) / 1000 * geometry.x_ratio) - realtime_delta,
                y = boundaries.y.max - (current_value.value * geometry.y_ratio),
                height = current_value.value * geometry.y_ratio
            };
        }
    }
}