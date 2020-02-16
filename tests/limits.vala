
private void register_limits() {

    Test.add_func("/LiveChart/Limits#UpdateValue", () => {
        //given
        var limits = new LiveChart.Limits();

        //when 
        limits.update(5.0);

        //then
        assert(limits.min == 0.0);
        assert(limits.max == 5.0);    
        
        //when
        limits.update(-1.0);

        //then
        assert(limits.min == -1.0);
        assert(limits.max == 5.0);

        //when
        limits.update(10.0);

        //then
        assert(limits.min == -1.0);
        assert(limits.max == 10.0);        
    });
}