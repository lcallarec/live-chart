
private void register_axis() {

    Test.add_func("/LiveChart/XAxis#ratio", () => {
        //given
        var axis = LiveChart.XAxis();
        axis.tick_interval = 30;
        axis.tick_length = 60;

        //when 
        var ratio = axis.ratio();
        
        //then
        assert(ratio == 2);
    });    
}