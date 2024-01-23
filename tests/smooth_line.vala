private void register_smooth_line() {
    Test.add_func("/SmoothLine/should_not_render_if_no_values", () => {
        //Given
        var context = create_context();

        var values = new LiveChart.Values();
       
        var line = new LiveChart.SmoothLine(values);
        line.line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);

        //Then
        assert(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });

    Test.add_func("/SmoothLine/should_render_smooth_line", () => {
        //Given
        var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };

        var context = create_context(43, 20);

        var values = new LiveChart.Values();
        values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
       
        var line = new LiveChart.SmoothLine(values);
        line.line.color = green;

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);

        //Then the curve colors are...
        assert(get_color_at(context)({x: 0, y: 14}) == green);
        assert(get_color_at(context)({x: 22, y: 0}) == green);
        assert(get_color_at(context)({x: 42, y: 14}) == green);

        //And below the curve, color is...
        assert(get_color_at(context)({x: 22, y: 7}) == DEFAULT_BACKGROUND_COLOR);
    });

    Test.add_func("/SmoothLine/should_render_smooth_line_with_region", () => {
        //Given
        var red = Gdk.RGBA() { red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        var green = Gdk.RGBA() { red = 0.0f, green = 1.0f, blue = 0.0f, alpha = 1.0f };

        var context = create_context(43, 20);

        var values = new LiveChart.Values();
        values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
       
        var line = new LiveChart.SmoothLine(values);
        line.line.color = green;
        line.region = new LiveChart.Region.between(10, 100).with_line_color(red);

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);

        //Then the curve colors are...
        assert(get_color_at(context)({x: 0, y: 14}) == green);
        assert(get_color_at(context)({x: 22, y: 0}) == red);
        assert(get_color_at(context)({x: 42, y: 14}) == green);
    });
}