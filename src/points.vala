using Gee;

namespace LiveChart {
    
     public struct Point {
        public double x;
        public double y;
        public double height;
    }
    
    public class Points<T> : Object {

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
       
    }
    public interface PointsFactory<T> : Object {
        public abstract Points<T?> create(Config config);
    }

    public class TimeStampedPointsFactory : PointsFactory<TimestampedValue?>, Object {
        private Values values;

        public TimeStampedPointsFactory(Values values) {
            this.values = values;
        }

        public Points<TimestampedValue?> create(Config config) {
            var boundaries = config.boundaries();

            var points = new Points<TimestampedValue?>();
            if (values.size > 0) {
                var last_value = values.last();
                var realtime_delta = (((GLib.get_real_time() / 1000) - last_value.timestamp) * config.x_axis.get_ratio()) / 1000;

                foreach (TimestampedValue value in values) {
                    var point = value_to_point(last_value, value, config, boundaries, realtime_delta);
                    points.add(point);
                }
            }
         
            return points as Points<TimestampedValue>;
        }

        public static Point value_to_point(TimestampedValue last_value, TimestampedValue current_value, Config config, Boundaries boundaries, double realtime_delta) {
            return Point() {
                x = (boundaries.x.max - (last_value.timestamp - current_value.timestamp) / 1000 * config.x_axis.get_ratio()) - realtime_delta,
                y = boundaries.y.max - (current_value.value * config.y_axis.get_ratio()),
                height = current_value.value * config.y_axis.get_ratio()
            };
        }
    }

    public class NamedPointsFactory : PointsFactory<NamedValue?>, Object {
        private StaticValues values;

        public NamedPointsFactory(StaticValues values) {
            this.values = values;
        }

        public Points<NamedValue?> create(Config config) {
            var boundaries = config.boundaries();

            var points = new Points<NamedValue?>();
            if (values.size > 0) {
                foreach (NamedValue value in values) {
                    var point = value_to_point(value, config, boundaries);
                    points.add(point);
                }
            }
         
              return points as Points<NamedValue>;
        }

        private static Point value_to_point(NamedValue current_value, Config config, Boundaries boundaries) {
            var category_length = config.categories.size;
            uint8 category_pos = 0;
            for (uint8 i = 0; i < category_length;i++) {
                var category = config.categories.get(i);
                if (category != null && category == current_value.name) {
                    category_pos = i;
                    break;
                }
            }
            var width_between_each_points = (boundaries.x.max - boundaries.x.min) / (category_length - 1);//TODO divide by 0
            var x = (boundaries.x.min + (category_pos * width_between_each_points));
            var y = boundaries.y.max - (current_value.value * config.y_axis.get_ratio());
            return Point() {
                x = x,
                y =y,
                height = current_value.value * config.y_axis.get_ratio()
            };
        }
    }
}