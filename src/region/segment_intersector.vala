namespace LiveChart {
    public class SegmentIntersector : RegionIntersector<Segment?> {
        private RegionResolver resolver;
        private Config config;

        public SegmentIntersector(RegionResolver resolver, Config config) {
            this.resolver = resolver;
            this.config = config;
        }
            
        public void intersect(Point previous, Point current, Segment? nothing) {
            resolver.resolve(previous, current, (value) => {
                return this.intersect_at({ 
                    from: { 
                        x: previous.x, 
                        y: previous.y 
                    }, 
                    to: {
                        x: current.x,
                        y: current.y 
                    }
                }, 
                value);
            });
        }
        
        private Coord? intersect_at(Segment segment, double at_value) {
            var intersection_segment = create_intersection_segment_at(at_value);
            return find_intersection_between_two_segments(intersection_segment, segment);
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