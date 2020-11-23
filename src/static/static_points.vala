using Gee;
using LiveChart;

namespace LiveChart.Static {

    public class StaticPoints : Object {

        private Gee.ArrayList<Point?> points = new Gee.ArrayList<Point?>();
        public Bounds bounds {
            get; construct set;
        }

        public StaticPoints() {
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

        public static StaticPoints create(StaticValues values, Config config) {
            var boundaries = config.boundaries();

            StaticPoints points = new StaticPoints();
            if (values.size > 0) {
                foreach (NamedValue value in values) {
                    var point = StaticPoints.value_to_point(value, config, boundaries);
                    points.add(point);
                }
            }
         
            return points;
        }

        private static Point value_to_point(NamedValue current_value, Config config, Boundaries boundaries) {
            var category_length = config.categories.size;
            uint8 category_pos = 0;
            for (uint8 i = 0; i < category_length;i++) {
                var category = config.categories.get(i);
                if (category != null && category == current_value.name) {
                    category_pos = i;
                    message("Found category %s at pos %d".printf(category, i));
                    break;
                }
            }
            var width_between_each_points = (boundaries.x.max - boundaries.x.min) / (category_length - 1);//TODO divide by 0
            message("WIDTH %d".printf(config.width));
            var x = (boundaries.x.min + (category_pos * width_between_each_points));
            var y = boundaries.y.max - (current_value.value * config.y_axis.get_ratio());
             message("category %s at pos %d (%f,%f) (width_between_each_points = %d) ratio: %f".printf(current_value.name, category_pos, x, y, width_between_each_points, config.x_axis.get_ratio()));
            return Point() {
                x = x,
                y =y,
                height = current_value.value * config.y_axis.get_ratio()
            };
        }
    }
}