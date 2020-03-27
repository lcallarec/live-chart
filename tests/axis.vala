
private void register_axis() {

    Test.add_func("/LiveChart/XAxis#Ratio", () => {
        //given
        var axis = new LiveChart.XAxis();
        axis.tick_interval = 30;
        axis.tick_length = 60;

        //when 
        var ratio = axis.get_ratio();
        
        //then
        assert(ratio == 2);
    });

    Test.add_func("/LiveChart/YAxis#UpdateRatioWithNoBoundsSet", () => {
        //given
        var axis = new LiveChart.YAxis();
        axis.tick_interval = 30;
        axis.tick_length = 60;

        //when 
        axis.update_ratio(100, 200);
        
        //then ratio shouldn't not de updated
        assert(axis.get_ratio() == 1);
    });

    Test.add_func("/LiveChart/YAxis#UpdateRatioWithBoundsSet", () => {
        //given
        var axis = new LiveChart.YAxis();
        axis.tick_interval = 30;
        axis.tick_length = 60;
        axis.update_bounds(10.0);

        //when 
        axis.update_ratio(100, 200);
        
        //then ratio shouldn't not de updated
        assert(axis.get_ratio() == 1);
    });

    Test.add_func("/LiveChart/YAxis#UpdateRatioWithBoundsSet#RatioUpdated", () => {
        //given
        var axis = new LiveChart.YAxis();
        axis.tick_interval = 30;
        axis.tick_length = 60;
        axis.update_bounds(200.0);

        //when 
        axis.update_ratio(100, 200);
        
        //then ratio should de updated
        assert(axis.get_ratio() * axis.get_ratio_threshold() == 0.5);
    });

    Test.add_func("/LiveChart/YAxis#UpdateRatioWithBoundsSet#FixedMax#SufficientAreaSize", () => {
        //given
        var axis = new LiveChart.YAxis();
        axis.tick_interval = 30;
        axis.fixed_max = 100;
        axis.update_bounds(80.0);

        //when 
        axis.update_ratio(100, 200);
        
        //then ratio should de updated
        assert(axis.get_ratio() == 1);
    });

    Test.add_func("/LiveChart/YAxis#UpdateRatioWithBoundsSet#FixedMax#UnsufficientAreaSize", () => {
        //given
        var axis = new LiveChart.YAxis();
        axis.tick_interval = 30;
        axis.fixed_max = 100;
        axis.update_bounds(100.0);

        //when 
        axis.update_ratio(30, 50);

        //then ratio should de updated
        assert(axis.get_ratio() == 0.3);
    });       
}