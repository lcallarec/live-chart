using Cairo;
using Gee;

namespace LiveChart {
    
    public class Serie : Object {

        private Gee.ArrayList<Point?> buffer = new Gee.ArrayList<Point?>();
        private const int MAX_BUFFER_SIZE = 10;
        private int64 time_start = new DateTime.now().to_unix();

        public string name { get; construct set;}
        public SerieRenderer renderer { get; set; default = new Line(); }

        public Serie(string name) {
            this.name = name;
        }

        public void add(double value) {
            buffer.add({new DateTime.now().to_unix() - time_start, value});
        }

        public void render(Context ctx, Geometry geometry) {
            if (buffer.size == 0) return;
            this.renderer.render(ctx, geometry, buffer);
        }
    }
}