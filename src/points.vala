using Cairo;
using Gee;

namespace LiveChart {
    
    public class Points : Object {

        private Gee.ArrayList<Point?> points = new Gee.ArrayList<Point?>();
        private const int MAX_BUFFER_SIZE = 10;
        private int64 time_start = new DateTime.now().to_unix();

        public int size {
            get {
                return points.size;
            }
        }

        public void add(Point point) {
            points.add({point.x - time_start, point.y});
        }

        public void add_raw(Point point) {
            points.add(point);
        }

        public new Point get(int at) {
            return points.get(at);
        }

        public Point after(int at) {
            if (at == size - 1) return this.get(at);
            return this.get(at + 1);
        }

        public Point before(int at) {
            if (at == 0) return this.get(at);
            return this.get(at - 1);
        }

        public Point last() {
            return this.get(this.size - 1);
        }

        public Point first() {
            return this.get(0);
        }

        public Points translate(Geometry geometry) {
            var boundaries = geometry.boundaries();

            Points translated_points = new Points();
            var raw_last_point = points.last();

            foreach (Point point in points) {
                translated_points.add_raw(Point() {
                    x = boundaries.x.max - raw_last_point.x + point.x,
                    y =  boundaries.y.max - (point.y *  geometry.y_ratio)
                });
            }
            return translated_points;
        }
    }
}