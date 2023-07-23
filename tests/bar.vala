private void register_bar() {
    Test.add_func("/Bar/should_draw_bars_at_specified_values", () => {
        //Given
        var WIDTH = 10;
        var HEIGHT = 10;
        var context = create_context(WIDTH, HEIGHT);

        var red = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        var now = GLib.get_real_time() / 1000;
        var values = new LiveChart.Values();
        values.add({timestamp: now, value: 10 });
        values.add({timestamp: now - 3000, value: 5 });
        values.add({timestamp: now - 6000, value: 6 });

        var bar = new LiveChart.Bar(values);
        bar.line.color = red;

        //When
        var config = create_config(WIDTH, HEIGHT);
        config.x_axis.tick_length = 1;
        config.x_axis.tick_interval = 1;
        config.padding = LiveChart.Padding() {smart = LiveChart.AutoPadding.NONE, top = 0, right = 0, bottom = 0, left = 0};
        bar.draw(context.ctx, config);
 
        //Then
        assert(has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 0));
        assert(has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 1));

        assert(get_color_at(context)({x: 5, y: 5}).equal(red));
    });

    Test.add_func("/Bar/should_not_render_anything_if_there_are_no_values", () => {
        //Given
        var context = create_context();

        var values = new LiveChart.Values();
       
        var red = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        var bar = new LiveChart.Bar(values);
        bar.line.color = red;

        //When
        bar.draw(context.ctx, create_config());
 
        //Then
        assert(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });
}
