
private void register_intersections() {
    
    Test.add_func("/Intersectors/BezierIntersector/should_find_intersection_in_the_middle_of_arc", () => {
        //given
        var above5 = new LiveChart.Region.between(5, double.MAX);

        //Quart of arc
        LiveChart.Point previous = {
            x : 0,
            y: 0,
            height: 0,
            data: {
                timestamp: 0,
                value: 0,
            }
        };

        LiveChart.Point target = {
            x : 10,
            y: 10,
            height: 0,
            data: {
                timestamp: 10,
                value: 10,
            }
        };

        var curve = LiveChart.build_bezier_curve_from_points(previous, target);
        var resolver = new LiveChart.SmoothLineRegionResolver(above5);
        var intersector = new LiveChart.BezierIntersector(resolver, create_config());

        //when
        intersector.intersect(previous, target, curve);

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert(Math.fabs(intersections.get(0).start_x - 5f) <= EPSILON);
        assert(Math.fabs(intersections.get(0).end_x - 5f) <= EPSILON);
    });
}