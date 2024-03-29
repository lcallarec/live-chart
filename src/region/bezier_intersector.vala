namespace LiveChart {
    public class BezierIntersector : RegionIntersector<BezierCurve?> {
        private RegionResolver resolver;
        private Config config;

        public BezierIntersector(RegionResolver resolver, Config config) {
            this.resolver = resolver;
            this.config = config;
        }
            
        public void intersect(Point previous, Point current, BezierCurve? curve) {
            resolver.resolve(previous, current, (value) => {
                return this.intersect_at(curve, value);
            });
        }
        
        private Coord? intersect_at(BezierCurve curve, double at_value) {
            var intersection_segment = create_intersection_segment_at(at_value);
            var intersection_coords = find_intersections_between_segment_and_curve(intersection_segment, curve);
            if(intersection_coords.size > 0) {
                return intersection_coords.first();
            };
            return null;
        }
    
        private Segment create_intersection_segment_at(double at_value) {
            var boundaries = this.config.boundaries();
            var y = boundaries.y.max - (at_value * config.y_axis.get_ratio());
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