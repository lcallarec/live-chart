
private void register_bounds() {

    Test.add_func("/LiveChart/Bounds#UpdateBounds", () => {
        //given
        var bounds = new LiveChart.Bounds();
   
        //when 
        var updated = bounds.update(5.0);

        //then
        assert(bounds.lower == 5.0);
        assert(bounds.upper == 5.0);
        assert(updated == true);
        
        //when
        updated = bounds.update(-1.0);

        //then
        assert(bounds.lower == -1.0);
        assert(bounds.upper == 5.0);
        assert(updated == true);

        //when
        updated = bounds.update(10.0);

        //then
        assert(bounds.lower == -1.0);
        assert(bounds.upper == 10.0);
        
        //when
        updated = bounds.update(10.0);

        //then
        assert(updated == false);
        
    });
}