
private void register_geometry() {

    Test.add_func("/LiveChart/Geometry#Boundaries", () => {
        //given
        var geometry = LiveChart.Geometry() {
            width = 100,
            height = 200,
            padding = { 20, 25, 10, 30 }
        };

        //when 
        var boundaries = geometry.boundaries();
        //then
        assert(boundaries.x.min == 30);
        assert(boundaries.x.max == 75);
        assert(boundaries.y.min == 20);
        assert(boundaries.y.max == 190);
    });
}