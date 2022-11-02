namespace LiveChart {
    public interface Intersector<T> {
        public abstract void intersect(Intersections intersections, Point previous, Point current, T path);
    }

    public class BezierIntersector : Intersector<BezierCurve?> {
        private Region region;
        private Config config;
    
        public BezierIntersector(Region region, Config config) {
            this.region = region;
            this.config = config;
        }
    
        public void intersect(Intersections intersections, Point previous, Point current, BezierCurve? path) {
            region.handle(intersections, previous, current, (value) => {
                return this.intersect_at(config, path, value);
            });
        }
    
        private Coord? intersect_at(Config config, BezierCurve curve, double at_value) {
            var intersection_segment = create_intersection_segment_at(config, at_value);
            var intersections = find_intersections_between(intersection_segment, curve);
            if(intersections.size > 0) {
                return intersections.first();
            };
            return null;
        }
    
        private Segment create_intersection_segment_at(Config config, double at_y) {
            var boundaries = config.boundaries();
            var y = boundaries.y.max - (at_y * config.y_axis.get_ratio());
            return {
                from: {
                    x: boundaries.x.min,
                    y,
                },
                to: {
                    x: boundaries.x.max,
                    y
                }
            };
        }
    }
    
}