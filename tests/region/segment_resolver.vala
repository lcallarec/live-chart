using LiveChart;

private void register_regions_point_resolver() {

    //Region
    Test.add_func("/Region/PointRegionResolver/should_not_create_any_intersection_when_a_point_does_not_cross_any_threshold", () => {
        //given
        var region = new Region.between(1000, 2000);
        var resolver = new PointRegionResolver(region);

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
    Test.add_func("/Region/PointRegionResolver/should_create_an_intersection_when_a_point_does_cross_a_threshold", () => {
        //given
        var region = new Region.between(100, 200);
        var resolver = new PointRegionResolver(region);

        //when
        resolver.resolve(
            new PointBuilder.from_value(90).build(),
            new PointBuilder.from_value(120).build(),
            (value) => {
                return { x: 120, y: 0 };
            }
        );

        //then
        var intersections = resolver.get_intersections();

        assert(intersections.size() == 1);
    });
}
