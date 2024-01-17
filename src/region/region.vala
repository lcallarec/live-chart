using Cairo;

namespace LiveChart {

    public delegate Coord? GetIntersection(double at_value);

    public interface RegionIntersector<T> {
        public abstract void intersect(Point previous, Point current, T path);
    }

    public interface RegionResolver : Object {
        public abstract Region get_region();
        public abstract Intersections get_intersections();
        public abstract void resolve(Point previous, Point current, GetIntersection get_intersection);
    }

    public class Region {
        public Gdk.RGBA? line_color { get; set; }
        public Gdk.RGBA? area_color { get; set; }

        public double floor { get; set; }
        public double ceil { get; set; }

        public Region(double floor, double ceil) {
            this.floor = floor;
            this.ceil = ceil;
        }

        public bool has_line_color() {
            return this.line_color != null;
        }

        public bool has_area_color() {
            return this.area_color != null;
        }

        public Region.between(double above, double below) {
            this(above, below);
        }

        public Region with_line_color(Gdk.RGBA color) {
            this.line_color = color;
            return this;
        }
        public Region with_area_color(Gdk.RGBA color) {
            this.area_color = color;
            return this;
        }
    }
}