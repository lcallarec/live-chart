using Cairo;

namespace LiveChart {
    public enum RegionHandleStatus {
        ENTER,
        EXIT,
        WITHIN,
        OUT
    }

    public struct RegionHandleResult {
        RegionHandleStatus status;
        double at_value;
    }

    public delegate Coord? GetIntersection(double at_value);

    public class Region {
        private double ceil;
        private double floor;

        public Gdk.RGBA line_color { get; set; default = Gdk.RGBA () { red = 1f, green = 1f, blue = 1f, alpha = 1f }; }
        public Gdk.RGBA area_color { get; set; default = Gdk.RGBA () { red = 1f, green = 1f, blue = 1f, alpha = 0.5f }; }

        public Region(double floor, double ceil) {
            this.floor = floor;
            this.ceil = ceil;
        }

        //  public Region.above(double above) {
        //      this(above, double.MAX);
        //  }
        
        //  public Region.below(double below) {
        //      this(-double.MAX, below);
        //  }
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

        public bool has_at_least_one_point_within(Point previous, Point current) {
            return previous.data.value  > this.floor && previous.data.value  <= this.ceil || current.data.value > this.floor && current.data.value <= this.ceil;
        }

        public void handle(Intersections intersections, Point previous, Point current, GetIntersection get_intersection) {
            if (this.has_at_least_one_point_within(previous, current)) {
                if (this.enter_by_the_bottom(previous, current)) {
                    var entered_at = this.floor;
                    var coords = get_intersection(entered_at);
                    if(intersections.has_an_opened_intersection()) {
                        intersections.update(current.x);
                    } else {
                        intersections.open(this, coords.x, entered_at);
                    }
                }
                if (this.enter_by_the_top(previous, current)) {

                    var entered_at = this.ceil;
                    var coords = get_intersection(entered_at);

                    if(intersections.has_an_opened_intersection()) {
                        intersections.update(current.x);
                    } else {
                        intersections.open(this, coords.x, entered_at);
                    }
                }

                if (this.leaving_by_the_top(previous, current)) {
                    var exited_at = this.ceil;
                    var coords = get_intersection(exited_at);

                    if(intersections.has_an_opened_intersection()) {
                        intersections.close(coords.x, exited_at);
                    } else {
                        intersections.open_without_entrypoint(this, previous.x);
                        intersections.close(coords.x, exited_at);
                    }
                }
                if (this.leaving_by_the_bottom(previous, current)) {
                    var exited_at = this.floor;
                    var coords = get_intersection(exited_at);

                    if(intersections.has_an_opened_intersection()) {
                        intersections.close(coords.x, exited_at);
                    } else {
                        intersections.open_without_entrypoint(this, previous.x);
                        intersections.close(coords.x, exited_at);
                    }
                }
                if(this.is_within(previous, current)) {
                    if(!intersections.has_an_opened_intersection()) {
                        intersections.open_without_entrypoint(this, previous.x);
                    } else {
                        intersections.update(current.x);
                    }
                }
            }
        }

        private bool enter_by_the_bottom(Point previous, Point current) {
            return previous.data.value <= this.floor && current.data.value > this.floor;
        }

        private bool enter_by_the_top(Point previous, Point current) {
            return previous.data.value >= this.ceil && current.data.value < this.ceil;
        }

        private bool leaving_by_the_top(Point previous, Point current) {
            return previous.data.value >= this.floor && current.data.value  > this.ceil;
        }

        private bool leaving_by_the_bottom(Point previous, Point current) {
            return previous.data.value >= this.floor && current.data.value  < this.floor;
        }

        private bool is_within(Point previous, Point current) {
            return previous.data.value >= this.floor && current.data.value > this.floor && previous.data.value < this.ceil && current.data.value < this.ceil ;
        }
    }
}