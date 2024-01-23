
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

    
    Test.add_func("/XAxis/with_slide_timeline", () => {
        
        //## GIVEN
        var WIDTH = 100;
        var HEIGHT = 100;
        
        var red = Gdk.RGBA(){red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f};

        var context = create_context(WIDTH, HEIGHT);
        
        var config = new LiveChart.Config();
        config.height = HEIGHT;
        config.width = WIDTH;
        config.y_axis.update_bounds(10);
        config.y_axis.lines.visible = false;
        
        //Vertical grid: render each 20 [sec], 10[px]
        //Abscissa part is not rendered because this is just for sliding vgrid test.
        config.x_axis.slide_timeline = true;
        config.x_axis.tick_interval = 20;
        config.x_axis.tick_length = 10;
        config.x_axis.lines.color = red;
        config.x_axis.lines.width = 2;
        config.x_axis.axis.visible = false;
        
        //410 [sec] after 1970-01-01 00:00:00 UTC
        config.time.current = 400 * config.time.conv_sec;
        config.time.current += (10 * config.time.conv_sec);
        config.padding.right = 10;
        config.configure(context.ctx, null);
        
        var grid = new LiveChart.Grid();
        
        //## WHEN
        grid.draw(context.ctx, config);
        screenshot(context);
        
        //## THEN
        
        //The 2nd grid must be rendered in 15[px] left from the pos of right padding.
        // -> Interval len of vgrid is 10[px],
        // -> Interval time of vgrid is 20[sec]
        // -> Current time(=right edge of plotting area) is 410[sec] = 20(tick_interval) * 20 + 10(surplus).
        // -> then, in this case, gap from the right edge is here: 5[px] = 10[px] * 10[sec](surplus) / 20[sec](interval)
        var init_x = config.width - config.padding.right - 10 - 5;
        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, WIDTH, HEIGHT);

        //Edge of the line tends to be blurred ? It bothers the alpha color picking test.
        var from_y = config.padding.top + 1;
        var to_y = config.height - config.padding.bottom - 1;
        
        assert(has_only_one_color_in_rectangle(context, init_x, (int)from_y, init_x, (int)to_y)(red));
    });
    
    Test.add_func("/YAxis/should_not_update_ratio_when_bounds_are_not_set", () => {
        //given
        var axis = new LiveChart.YAxis();

        //when 
        axis.update(100);
        
        //then ratio shouldn't not de updated
        assert(axis.get_ratio() == 1);
    });

    Test.add_func("/YAxis/should_not_update_ratio_when_threshold_is_1_even_if_bounds_are_set", () => {
        //given
        var axis = new LiveChart.YAxis();
        axis.update_bounds(10.0);
        axis.ratio_threshold = 1f;

        //when 
        axis.update(100);
        
        //then ratio shouldn't not be updated
        assert(axis.get_ratio() == 10);
    });

    Test.add_func("/YAxis/should_update_ratio_when_bounds_are_updated", () => {
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