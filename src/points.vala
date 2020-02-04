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

        public void add(double value) {
            points.add({new DateTime.now().to_unix() - time_start, value});
        }

        public new Point get(int at) {
            return points.get(at);
        }

    }
}