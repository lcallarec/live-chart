
private void register_axis() {

    Test.add_func("/XAxis/should_compute_ratio_based_on_tick_interval_and_tick_length", () => {
        //given
        var axis = new LiveChart.XAxis();
        axis.tick_interval = 30;
        axis.tick_length = 60;

        //when 
        var ratio = axis.get_ratio();
        
        //then
        assert(ratio == 2);
    });

    Test.add_func("/YAxis/should_not_update_ratio_when_bounds_are_not_set", () => {
        //given
        var axis = new LiveChart.YAxis();

        //when 
        axis.update(100);
        
        //then ratio shouldn't not de updated
        assert(axis.get_ratio() == 1);
    });

    Test.add_func("/YAxis/should_not_update_ratio_when_threshold_is_1_even_if_boubds_are_set", () => {
        //given
        var axis = new LiveChart.YAxis();
        axis.update_bounds(10.0);
        axis.ratio_threshold = 1f;

        //when 
        axis.update(100);
        
        //then ratio shouldn't not be updated
        assert(axis.get_ratio() == 10);
    });

    Test.add_func("/YAxis/should_update_ratio_when_boubds_are_updated", () => {
        //given
        var axis = new LiveChart.YAxis();
        axis.ratio_threshold = 1f;
        axis.update_bounds(200.0);

        //when 
        axis.update(100);
        
        //then ratio should de updated
        assert(axis.get_ratio() == 0.5);
    });

    Test.add_func("/YAxis/UpdateRatioWithBoundsSet#FixedMax#SufficientAreaSize", () => {
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

    Test.add_func("/YAxis/UpdateRatioWithBoundsSet#FixedMax#UnsufficientAreaSize", () => {
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

    Test.add_func("/YAxis/get_max_displayed_values", () => {
        //given
        var y_axis = new LiveChart.YAxis();
        y_axis.unit = "GB";

        //when
        y_axis.ticks = LiveChart.Ticks();
        y_axis.ticks.values.add(0f);
        y_axis.ticks.values.add(0.1f);
        y_axis.ticks.values.add(0.57f);
        y_axis.ticks.values.add(2f);
        
        var max_displayed_value = y_axis.get_max_displayed_value();

        //then
        assert(max_displayed_value == "0,57GB" || max_displayed_value == "0.57GB");
    });

    Test.add_func("/YAxis/get_max_displayed_values_with_no_values", () => {
        //given
        var y_axis = new LiveChart.YAxis();
        y_axis.ticks = LiveChart.Ticks();
        y_axis.unit = "GB";

        //when  //then should not crash
        y_axis.get_max_displayed_value();
    });

    Test.add_func("/YAxis/get_ticks_with_fixed_max", () => {
        //given
        var y_axis = new LiveChart.YAxis();
        y_axis.fixed_max = 100.0;
        y_axis.tick_interval = 25;

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

    Test.add_func("/YAxis/get_ticks_with_defaults_and_no_values", () => {
        //given
        var y_axis = new LiveChart.YAxis();

        //when
        var ticks = y_axis.get_ticks();

        //then
        assert(ticks.values.size == 0);
    });


    Test.add_func("/YAxis/get_ticks_with_defaults_and_bounds", () => {
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
    
    Test.add_func("/YAxis/get_ticks_with_defaults_and_bounds_to_value_below 1", () => {
     
        var y_axis = new LiveChart.YAxis();
        y_axis.update_bounds(0.05);

        //when
        var ticks = y_axis.get_ticks();

        //then
        assert(ticks.values.size == 4);
        assert(ticks.values.get(0) == 0f);
        assert(ticks.values.get(1) == 0.02f);
        assert(ticks.values.get(2) == 0.04f);
        assert(ticks.values.get(3) == 0.06f);
    });

    Test.add_func("/YAxis/get_ticks_with_defaults_and_bounds_to_value_just_above 1", () => {
     
        var y_axis = new LiveChart.YAxis();
        y_axis.update_bounds(1.05);

        //when
        var ticks = y_axis.get_ticks();

        //then
        assert(ticks.values.size == 4);
        assert(ticks.values.get(0) == 0f);
        assert(ticks.values.get(1) == 0.4f);
        assert(ticks.values.get(2) == 0.8f);
        assert(ticks.values.get(3) == 1.2f);
    });

    Test.add_func("/YAxis/get_ticks_should_not_crash_when_max_value_is_zero", () => {
     
        var y_axis = new LiveChart.YAxis();
        y_axis.update_bounds(0);

        //when //then
        y_axis.get_ticks();
    });
}