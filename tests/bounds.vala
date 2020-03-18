
private void register_bounds() {

    Test.add_func("/LiveChart/Bounds#UpdateBounds", () => {
        //given
        var lower_bound_updated = false;
        var upper_bound_updated = false;        
        
        var bounds = new LiveChart.Bounds();
        bounds.lower_bound_updated.connect(() => {
            lower_bound_updated = true;
        });
        bounds.upper_bound_updated.connect(() => {
            upper_bound_updated = true;
        });        
        //when 
        bounds.update(5.0);

        //then
        assert(bounds.lower == 0.0);
        assert(bounds.upper == 5.0);
        assert(lower_bound_updated == false);
        assert(upper_bound_updated == true);
        
        //when

        bounds.update(-1.0);

        //then
        assert(bounds.lower == -1.0);
        assert(bounds.upper == 5.0);
        assert(lower_bound_updated == true);

        //when
        bounds.update(10.0);

        //then
        assert(bounds.lower == -1.0);
        assert(bounds.upper == 10.0);        
    });
}