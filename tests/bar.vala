private void register_bar() {

    Test.add_func("/Bar/should_draw_bars_at_specified_values", () => {
        //Given
        var now = GLib.get_real_time() / 1000;

        var context = create_context(10, 10);

        var red = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        var values = new LiveChart.Values();
        values.add({timestamp: now, value: 10 });
        values.add({timestamp: now - 3000, value: 5 });
        values.add({timestamp: now - 6000, value: 6 });

        var bar = new LiveChart.Bar(values);
        bar.line.color = red;

        //When
        var config = create_config(context);
        config.x_axis.tick_length = 1;
        config.x_axis.tick_interval = 1;

        config.padding = LiveChart.Padding() {smart = LiveChart.AutoPadding.NONE, top = 0, right = 0, bottom = 0, left = 0};
        bar.draw(context.ctx, config);
        screenshot(context);

        //Then
        assert(has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 0));
        assert(has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 1));

        assert(get_color_at(context)({x: 5, y: 5}).equal(red));
    });

    Test.add_func("/Bar/should_not_render_anything_if_there_are_no_values", () => {
        //Given
        var context = create_context(10, 10);

        var values = new LiveChart.Values();
       
        var red = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        var bar = new LiveChart.Bar(values);
        bar.line.color = red;

        //When
        bar.draw(context.ctx, create_config(context));
        screenshot(context);
 
        //Then
        assert(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });

    Test.add_func("/Bar/Regions", () => {
        Test.add_func("/Bar/Regions/should_render_red_bar_when_value_is_above_", () => {
            //Given
            var context = create_context(60, 20);
            var now = GLib.get_real_time() / 1000;

            var values = new LiveChart.Values();
            values.add({timestamp: now, value: 10 });
            values.add({timestamp: now - 3000, value: 15 });
            values.add({timestamp: now - 6000, value: 10 });
            values.add({timestamp: now - 9000, value: 5 });
           
            var red = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
            var green = Gdk.RGBA() {red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };

            var bar = new LiveChart.Bar(values);
            bar.region = new LiveChart.Region.between(12, 20).with_area_color(red);

            bar.line.color = green;
    
            //When
            bar.draw(context.ctx, create_config(context));
            screenshot(context);
     
            //Then
            assert(get_color_at(context)({x: 10, y: 18}) == green);
            assert(get_color_at(context)({x: 30, y: 18}) == red);
            assert(get_color_at(context)({x: 50, y: 18}) == green);
        });
    });
}
