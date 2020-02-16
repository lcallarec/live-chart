
private void register_geometry() {

    Test.add_func("/LiveChart/Geometry#Boundaries", () => {
        //given
        var geometry = new LiveChart.Geometry();
        geometry.width = 100;
        geometry.height = 200;
        geometry.padding = { 20, 25, 10, 30 };

        //when 
        var boundaries = geometry.boundaries();
        
        //then
        assert(boundaries.x.min == 30);
        assert(boundaries.x.max == 75);
        assert(boundaries.y.min == 20);
        assert(boundaries.y.max == 190);
    });
}