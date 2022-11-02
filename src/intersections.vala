namespace LiveChart {
    public class Intersections : Object {
        private Gee.List<Intersection?> intersections = new Gee.ArrayList<Intersection?>();

        public void close(double x, double exited_at) {
            intersections.last().close(x, exited_at);
        }

        public void update(double x) {
            intersections.last().update(x);
        }

        public void open(Region region, double x, double entered_at) {
            var intersection = new Intersection(region, x, entered_at);
            intersections.add(intersection);
        }

        public void open_without_entrypoint(Region region, double x) {
            var intersection = new Intersection.without_entry_point(region, x);
            intersections.add(intersection);
        }

        public void foreach(Gee.ForallFunc<Intersection?> f) {
            intersections.foreach(f);
        }

        public bool has_an_opened_intersection() {
            return intersections.size > 0 && intersections.last().is_open();
        }
        public Region get_current_region() {
            return intersections.last().region;
        }

        public int size() {
            return intersections.size;
        }

        public new Intersection @get(int index) {
            return intersections.get(index);
        }
    }
    
    public class Intersection : Object {
        public Region region { get; construct set; }
        public double start_x { get; private set; }
        public double end_x  { get; private set; }
        public double? entered_at;
        public double? exited_at;

        public Intersection(Region region, double start_x, double entered_at) {
            this.region = region;
            this.start_x = start_x;
            this.end_x = start_x;
            this.entered_at = entered_at;
        }
        public Intersection.without_entry_point(Region region, double start_x) {
            this.region = region;
            this.start_x = start_x;
            this.end_x = start_x;
        }

        public void update(double x) {
            this.end_x = x;
        }

        public void close(double x, double exited_at) {
            this.end_x = x;
            this.exited_at = exited_at;
        }

        public bool is_open() {
            return this.exited_at == null;
        }

        public bool is_closed() {
            return this.exited_at != null;
        }
    }
}