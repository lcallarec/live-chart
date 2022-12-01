using Gee;

namespace LiveChart {
     public struct Point {
        public double x;
        public double y;
        public double height;
        public TimestampedValue data;
    }
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

        public static Points create(Values values, Config config) {
            var boundaries = config.boundaries();

            Points points = new Points();
            if (values.size > 0) {
                var last_value = values.last();
                points.realtime_delta = (((GLib.get_real_time() / 1000) - last_value.timestamp) * config.x_axis.get_ratio()) / 1000;

                foreach (TimestampedValue value in values) {
                    var point = Points.value_to_point(last_value, value, config, boundaries, points.realtime_delta);
                    points.add(point);
                }
            }
         
            return points;
        }

        private static Point value_to_point(TimestampedValue last_value, TimestampedValue current_value, Config config, Boundaries boundaries, double realtime_delta) {
            return Point() {
                x = (boundaries.x.max - (config.time.current - current_value.timestamp) 
                    * config.x_axis.get_ratio() / config.time.conv_sec),
                y = boundaries.y.max - (current_value.value * config.y_axis.get_ratio()),
                height = current_value.value * config.y_axis.get_ratio(),
                data = current_value
            };
        }
    }
}