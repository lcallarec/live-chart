using LiveChart;

private void register_regions_curve_resolver() {

    //Region
    //No thresold crossed
    Test.add_func("/Region/CurveRegionResolver/should_not_create_any_intersection_when_a_point_does_not_cross_any_threshold", () => {
        //given
        var region = new Region.between(1000, 2000);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(90).build(),
            new PointBuilder.from_value(100).build(),
            (value) => {
                return null;
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 0);
    });

    //Thresold crossed
    Test.add_func("/Region/CurveRegionResolver/should_create_an_open_intersection_when_point_is_entering_the_region_by_the_bottom", () => {
        //given
        var min = 100.0;
        var max = 500.0;
        var region = new Region.between(min, max);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(90).build(),
            new PointBuilder.from_value(150).build(),
            (value) => {
                return { x: 100, y: 50 };
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert_true(intersections.get(0).is_open());
        assert(intersections.get(0).entered_at == min);
        assert(intersections.get(0).start_x == 100);
        assert(intersections.get(0).end_x == 100);
    });

    Test.add_func("/Region/CurveRegionResolver/should_create_an_open_intersection_when_point_is_entering_the_region_by_the_top", () => {
        //given
        var min = 100.0;
        var max = 500.0;
        var region = new Region.between(min, max);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(600).build(),
            new PointBuilder.from_value(400).x(100).build(),
            (value) => {
                return { x: 100, y: 50 };
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert_true(intersections.get(0).is_open());
        assert(intersections.get(0).entered_at == max);
        assert(intersections.get(0).start_x == 100);
        assert(intersections.get(0).end_x == 100);
    });

    Test.add_func("/Region/CurveRegionResolver/should_create_an_open_intersection_when_point_is_already_inside_the_region_and_leave_immediately_by_the_bottom", () => {
        //given
        var min = 40.0;
        var max = 100.0;
        var region = new Region.between(min, max);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(60).x(100).build(),
            new PointBuilder.from_value(20).x(200).build(),
            (value) => {
                return { x: 250, y: 20};
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert(intersections.get(0).is_closed());

        assert(intersections.get(0).entered_at == null);
        assert(intersections.get(0).exited_at == min);

        assert(intersections.get(0).start_x == 100);
        assert(intersections.get(0).end_x == 250);
    });

    Test.add_func("/Region/CurveRegionResolver/should_create_an_open_intersection_when_point_is_already_inside_the_region_and_leave_by_the_bottom_after_a_while", () => {
        //given
        var min = 40.0;
        var max = 100.0;
        var region = new Region.between(min, max);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(60).x(100).build(),
            new PointBuilder.from_value(70).x(200).build(),
            (value) => {
                return { x: 100, y: 20};
            }
        );
        resolver.resolve(
            new PointBuilder.from_value(70).x(200).build(),
            new PointBuilder.from_value(30).x(300).build(),
            (value) => {
                return { x: 300, y: 20};
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert(intersections.get(0).is_closed());

        assert(intersections.get(0).entered_at == null);
        assert(intersections.get(0).exited_at == min);

        assert(intersections.get(0).start_x == 100);
        assert(intersections.get(0).end_x == 300);
    });

    Test.add_func("/Region/CurveRegionResolver/should_create_an_open_intersection_when_point_is_already_inside_the_region_and_leave_by_the_top", () => {
        //given
        var min = 40.0;
        var max = 100.0;
        var region = new Region.between(min, max);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(70).x(100).build(),
            new PointBuilder.from_value(95).x(200).build(),
            (value) => {
                return { x: 100, y: 20};
            });
        resolver.resolve(
            new PointBuilder.from_value(95).x(200).build(),
            new PointBuilder.from_value(200).x(300).build(),
            (value) => {
                return { x: 200, y: 20};
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert(intersections.get(0).is_closed());

        assert(intersections.get(0).entered_at == null);
        assert(intersections.get(0).exited_at == max);

        assert(intersections.get(0).start_x == 100);
        assert(intersections.get(0).end_x == 200);
    });

    Test.add_func("/Region/CurveRegionResolver/should_create_an_open_intersection_when_point_is_already_inside_the_region_and_leave_immediately_by_the_top", () => {
        //given
        var min = 40.0;
        var max = 100.0;
        var region = new Region.between(min, max);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(60).x(100).build(),
            new PointBuilder.from_value(150).x(200).build(),
            (value) => {
                return { x: 250, y: 20};
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert(intersections.get(0).is_closed());

        assert(intersections.get(0).entered_at == null);
        assert(intersections.get(0).exited_at == max);

        assert(intersections.get(0).start_x == 100);
        assert(intersections.get(0).end_x == 250);
    });

    Test.add_func("/Region/CurveRegionResolver/should_create_an_open_intersection_when_points_stay_inside_the_region", () => {
        //given
        var min = 100.0;
        var max = 200.0;
        var region = new Region.between(min, max);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(110).x(100).build(),
            new PointBuilder.from_value(120).x(150).build(),
            (value) => {
                return { x: 100, y: 20};
            });
        resolver.resolve(
            new PointBuilder.from_value(120).x(150).build(),
            new PointBuilder.from_value(150).x(200).build(),
            (value) => {
                return null;
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
        assert(intersections.get(0).is_open());
        
        assert(intersections.get(0).entered_at == null);
        assert(intersections.get(0).start_x == 100);
        assert(intersections.get(0).end_x == 200);
    });

    //Boundaries / edge cases
    Test.add_func("/Region/CurveRegionResolver/should_not_consider_any_crossing_when_entering_by_the_top_if_no_intersections_are_found_by_geometry", () => {
        //given
        var min = 100.0;
        var max = 200.0;
        var region = new Region.between(min, max);
        var resolver = new CurveRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(200).build(),
            new PointBuilder.from_value(150).build(),
            (value) => {
                return null;
        });

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 0);
    });

    //InOutWaterlinePoints
    Test.add_func("/Region/CurveRegionResolver/InOutWaterlinePoints/shouln_not_crossing_if_always_below_floor_and_ceil", () => {
        //given
        var resolver = new InOutWaterlinePoints(10, 20);

        var previous = new PointBuilder.from_value(0).build();
        var current = new PointBuilder.from_value(1).build();

        //when //then
        assert_false(resolver.is_entering_by_the_bottom(previous, current));
        assert_false(resolver.is_entering_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_bottom(previous, current));
        assert_false(resolver.is_within(previous, current));
    });

    Test.add_func("/Region/CurveRegionResolver/InOutWaterlinePoints/sould_not_crossing_if_always_above_floor_and_ceil", () => {
        //given
        var resolver = new InOutWaterlinePoints(10, 20);

        var previous = new PointBuilder.from_value(22).build();
        var current = new PointBuilder.from_value(25).build();

        //when //then
        assert_false(resolver.is_entering_by_the_bottom(previous, current));
        assert_false(resolver.is_entering_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_bottom(previous, current));
        assert_false(resolver.is_within(previous, current));
    });

    Test.add_func("/Region/CurveRegionResolver/InOutWaterlinePoints/should_be_within", () => {
        //given
        var resolver = new InOutWaterlinePoints(10, 20);

        var previous = new PointBuilder.from_value(10).build();
        var current = new PointBuilder.from_value(15).build();

        //when //then
        assert_false(resolver.is_entering_by_the_bottom(previous, current));
        assert_false(resolver.is_entering_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_bottom(previous, current));
        assert_true(resolver.is_within(previous, current));
    });

    Test.add_func("/Region/CurveRegionResolver/InOutWaterlinePoints/should_entering_by_the_bottom", () => {
        //given
        var resolver = new InOutWaterlinePoints(10, 20);

        var previous = new PointBuilder.from_value(5).build();
        var current = new PointBuilder.from_value(15).build();

        //when //then
        assert_true(resolver.is_entering_by_the_bottom(previous, current));
        assert_false(resolver.is_entering_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_bottom(previous, current));
        assert_false(resolver.is_within(previous, current));
    });

    Test.add_func("/Region/CurveRegionResolver/InOutWaterlinePoints/should_entering_by_the_top", () => {
        //given
        var resolver = new InOutWaterlinePoints(10, 20);

        var previous = new PointBuilder.from_value(30).build();
        var current = new PointBuilder.from_value(15).build();

        //when //then
        assert_false(resolver.is_entering_by_the_bottom(previous, current));
        assert_true(resolver.is_entering_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_bottom(previous, current));
        assert_false(resolver.is_within(previous, current));
    });

    Test.add_func("/Region/CurveRegionResolver/InOutWaterlinePoints/should_leaving_by_the_top", () => {
        //given
        var resolver = new InOutWaterlinePoints(10, 20);

        var previous = new PointBuilder.from_value(15).build();
        var current = new PointBuilder.from_value(30).build();

        //when //then
        assert_false(resolver.is_entering_by_the_bottom(previous, current));
        assert_false(resolver.is_entering_by_the_top(previous, current));
        assert_true(resolver.is_leaving_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_bottom(previous, current));
        assert_false(resolver.is_within(previous, current));
    });

    Test.add_func("/Region/CurveRegionResolver/InOutWaterlinePoints/should_leaving_by_the_bottom", () => {
        //given
        var resolver = new InOutWaterlinePoints(10, 20);

        var previous = new PointBuilder.from_value(15).build();
        var current = new PointBuilder.from_value(5).build();

        //when //then
        assert_false(resolver.is_entering_by_the_bottom(previous, current));
        assert_false(resolver.is_entering_by_the_top(previous, current));
        assert_false(resolver.is_leaving_by_the_top(previous, current));
        assert_true(resolver.is_leaving_by_the_bottom(previous, current));
        assert_false(resolver.is_within(previous, current));
    });
}
