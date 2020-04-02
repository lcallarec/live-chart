
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
        axis.update(100);
        
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
        axis.update(100);
        
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
        axis.update(100);
        
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
        axis.update(100);
        
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
        axis.update(30);

        //then ratio should de updated
        assert(axis.get_ratio() == 0.3);
    });

    Test.add_func("/LiveChart/YAxis#get_max_displayed_values", () => {
        //given
        var y_axis = new LiveChart.YAxis();
        y_axis.unit = "GB";

        //when 
        y_axis.displayed_values.add("0GB");
        y_axis.displayed_values.add("1GB");
        y_axis.displayed_values.add("1.57GB");
        y_axis.displayed_values.add("2.5GB");
        
        //then
        assert(y_axis.get_max_displayed_values() == "1.57GB");
    });

    Test.add_func("/LiveChart/YAxis#get_max_displayed_values_with_no_values", () => {
        //given
        var y_axis = new LiveChart.YAxis();
        y_axis.unit = "GB";

        //when  //then should not crash
        y_axis.get_max_displayed_values();
    });

    Test.add_func("/LiveChart/YAxis#get_ticks_with_fixed_max", () => {
        //given
        var y_axis = new LiveChart.YAxis();
        y_axis.fixed_max = 100.0;
        y_axis.tick_interval = 25;
        y_axis.tick_length = 25;

        //when
        var ticks = y_axis.get_ticks();

        //then
        assert(ticks.values.size == 5);
        assert(ticks.values.get(0) == 0);
        assert(ticks.values.get(1) == 25);
        assert(ticks.values.get(2) == 50);
        assert(ticks.values.get(3) == 75);
        assert(ticks.values.get(4) == 100);
    });

    Test.add_func("/LiveChart/YAxis#get_ticks_with_defaults_and_no_values", () => {
        //given
        var y_axis = new LiveChart.YAxis();

        //when
        var ticks = y_axis.get_ticks();

        //then
        assert(ticks.values.size == 0);
    });


    Test.add_func("/LiveChart/YAxis#get_ticks_with_defaults_and_bounds", () => {
        // // For a self-caped value
            //given
            var y_axis = new LiveChart.YAxis();
            y_axis.update_bounds(10.0);

            //when
            var ticks = y_axis.get_ticks();


            //then
            assert(ticks.values.size == 6);
            assert(ticks.values.get(0) == 0);
            assert(ticks.values.get(1) == 2);
            assert(ticks.values.get(2) == 4);
            assert(ticks.values.get(3) == 6);
            assert(ticks.values.get(4) == 8);
            assert(ticks.values.get(5) == 10);

        // For a value that needs to be caped
            //given
            y_axis.update_bounds(12.50);

            //when
            ticks = y_axis.get_ticks();

            //then
            assert(ticks.values.size == 5);
            assert(ticks.values.get(0) == 0);
            assert(ticks.values.get(1) == 4);
            assert(ticks.values.get(2) == 8);
            assert(ticks.values.get(3) == 12);
            assert(ticks.values.get(4) == 16);

        // For a value that needs to be caped
            //given
            y_axis.update_bounds(712);

            //when
            ticks = y_axis.get_ticks();

            //then
            assert(ticks.values.size == 6);
            assert(ticks.values.get(0) == 0);
            assert(ticks.values.get(1) == 160);
            assert(ticks.values.get(2) == 320);
            assert(ticks.values.get(3) == 480);
            assert(ticks.values.get(4) == 640);
            assert(ticks.values.get(5) == 800);


        // For a value that needs to be caped
            //given
            y_axis.update_bounds(815);

            //when
            ticks = y_axis.get_ticks();

            //then
            assert(ticks.values.size == 7);
            assert(ticks.values.get(0) == 0);
            assert(ticks.values.get(1) == 150);
            assert(ticks.values.get(2) == 300);
            assert(ticks.values.get(3) == 450);
            assert(ticks.values.get(4) == 600);
            assert(ticks.values.get(5) == 750);
            assert(ticks.values.get(6) == 900);
        });
    
}