
using LiveChart;

private void register_segment_interector() {
    
    Test.add_func("/Intersectors/SegmentIntersector/should_find_intersection_in_the_middle_of_two_segments", () => {
        //given
        var above5 = new Region.between(5, double.MAX);

        var p1 = Point() {
            x = 0,
            y = 10,
            height = 10,
            data = {
                timestamp: 0,
                value: 0,
            }
        };
        var p2 = Point() {
            x = 10,
            y = 0,
            height = 10,
            data = {
                timestamp: 10,
                value: 20,
            }
        };

        var resolver = new CurveRegionResolver(above5);
        var intersector = new SegmentIntersector(resolver, create_config());

        //when
        intersector.intersect(p1, p2, null);

        ///then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert(Math.fabs(intersections.get(0).start_x - 5f) <= EPSILON);
        assert(Math.fabs(intersections.get(0).end_x - 5f) <= EPSILON);
    });
}