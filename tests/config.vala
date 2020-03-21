
private void register_config() {

    Test.add_func("/LiveChart/Config#Boundaries", () => {
        //given
        var config = new LiveChart.Config();
        config.width = 100;
        config.height = 200;
        config.padding = { 20, 25, 10, 30 };

        //when 
        var boundaries = config.boundaries();
        
        //then
        assert(boundaries.x.min == 30);
        assert(boundaries.x.max == 75);
        assert(boundaries.y.min == 20);
        assert(boundaries.y.max == 190);
        assert(boundaries.width == 45);
        assert(boundaries.height == 170);        
    });
}