private void register_line() {
    Test.add_func("/Line/shouldnt_render_if_no_values", () => {
        //Given
        var white = Gdk.RGBA() {red = 1.0f, green = 1.0f, blue = 1.0f, alpha = 1.0f };
        var context = create_context(40, 5);

        var values = new LiveChart.Values();
       
        var line = new LiveChart.Line(values);
        line.line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);
        
        //Then
        assert(has_only_one_color(context)(white));
    });
    Test.add_func("/Line/should_render_red_pyramid", () => {
        //Given
        var now = GLib.get_real_time() / 1000;

        var context = create_context(40, 10);

        var values = new LiveChart.Values();
        values.add({timestamp: now - 5000, value: 1});
        values.add({timestamp: now - 2500,  value: 5});
        values.add({timestamp: now, value: 1});

        var red = Gdk.RGBA() { red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        var line = new LiveChart.Line(values);
        line.line.color = red;

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);
        
        //Then
        var background = Gdk.RGBA() { red = 1.0f, green = 1.0f, blue = 1.0f, alpha = 1.0f };

        assert(get_color_at(context)({x: 10, y: 7}) == background);
        assert(get_color_at(context)({x: 10, y: 8}) == red);
        assert(get_color_at(context)({x: 10, y: 9}) == background);

        assert(get_color_at(context)({x: 24, y: 4}) == background);
        assert(get_color_at(context)({x: 24, y: 5}) == red);
        assert(get_color_at(context)({x: 24, y: 6}) == background);

        assert(get_color_at(context)({x: 38, y: 7}) == background);
        assert(get_color_at(context)({x: 38, y: 8}) == red);
        assert(get_color_at(context)({x: 30, y: 9}) == background);
    });

    Test.add_func("/Line/Region/should_render_red_pyramid_but_blue_top", () => {
        //Given
        var now = GLib.get_real_time() / 1000;

        var context = create_context(40, 10);

        var values = new LiveChart.Values();
        values.add({timestamp: now - 5000, value: 1});
        values.add({timestamp: now - 2500,  value: 5});
        values.add({timestamp: now, value: 1});

        var red = Gdk.RGBA() { red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        var blue = Gdk.RGBA() { red = 0.0f, green = 0.0f, blue = 1.0f, alpha = 1.0f };

        var line = new LiveChart.Line(values);
        line.line.color = red;
        line.region = new LiveChart.Region.between(3, 10).with_line_color(blue);

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);
        
        //Then
        var background = Gdk.RGBA() { red = 1.0f, green = 1.0f, blue = 1.0f, alpha = 1.0f };

        assert(get_color_at(context)({x: 10, y: 7}) == background);
        assert(get_color_at(context)({x: 10, y: 8}) == red);
        assert(get_color_at(context)({x: 10, y: 9}) == background);

        assert(get_color_at(context)({x: 24, y: 4}) == background);
        assert(get_color_at(context)({x: 24, y: 5}) == blue);
        assert(get_color_at(context)({x: 24, y: 6}) == background);

        assert(get_color_at(context)({x: 38, y: 7}) == background);
        assert(get_color_at(context)({x: 38, y: 8}) == red);
        assert(get_color_at(context)({x: 30, y: 9}) == background);
    });
    Test.add_func("/Line/Region/should_render_red_pyramid_but_transparent_blue_top", () => {
        //Given
        var now = GLib.get_real_time() / 1000;

        var context = create_context(40, 10);

        var values = new LiveChart.Values();
        values.add({timestamp: now - 5000, value: 1});
        values.add({timestamp: now - 2500,  value: 5});
        values.add({timestamp: now, value: 1});

        var red = Gdk.RGBA() { red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        var semi_blue = Gdk.RGBA() { red = 0.0f, green = 0.0f, blue = 1.0f, alpha = 0.5f };

        var line = new LiveChart.Line(values);
        line.line.color = red;
        line.region = new LiveChart.Region.between(3, 10).with_line_color(semi_blue);

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);
        
        //Then
        var background = Gdk.RGBA() { red = 1.0f, green = 1.0f, blue = 1.0f, alpha = 1.0f };
        var flattened_semi_blue = Gdk.RGBA() { red = 0.5f, green = 0.5f, blue = 1.0f, alpha = 1.0f };

        assert(get_color_at(context)({x: 10, y: 7}) == background);
        assert(get_color_at(context)({x: 10, y: 8}) == red);
        assert(get_color_at(context)({x: 10, y: 9}) == background);

        assert(get_color_at(context)({x: 24, y: 4}) == background);
        assert(get_color_at(context)({x: 24, y: 5}) == flattened_semi_blue);
        assert(get_color_at(context)({x: 24, y: 6}) == background);

        assert(get_color_at(context)({x: 38, y: 7}) == background);
        assert(get_color_at(context)({x: 38, y: 8}) == red);
        assert(get_color_at(context)({x: 30, y: 9}) == background);
    });
}