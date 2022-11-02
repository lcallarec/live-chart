private void register_smooth_line_area() {
    
    Test.add_func("/SmoothLineArea/should_not_render_if_no_values", () => {
        //Given
        var context = create_context();


        var values = new LiveChart.Values();
       
        var line = new LiveChart.SmoothLineArea(values);
        line.line.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        line.draw(context.ctx, create_config());
 
        //Then
        assert(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });   

    Test.add_func("/SmoothLineArea/should_render_a_smooth_line_with_area_below", () => {
        //Given
        var green = Gdk.RGBA() { red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0 };

        var context = create_context(43, 20);

        var values = new LiveChart.Values();
        values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
       
        var line = new LiveChart.SmoothLineArea(values);
        line.line.color = green;
        line.area_alpha = 0.5;

        //When
        line.draw(context.ctx, create_config(43, 20));
 
        //Then the curve colors are...
        assert(get_color_at(context)({x: 0, y: 14}) == green);
        assert(get_color_at(context)({x: 22, y: 0}) == green);
        assert(get_color_at(context)({x: 42, y: 14}) == green);

        //And below the curve, color is...
        var area_color = Gdk.RGBA() { red = 0.5, green = 1, blue = 0.5, alpha = 1 };
        assert(get_color_at(context)({x: 22, y: 7}).equal(area_color));
    });   

    Test.add_func("/SmoothLineArea/should_render_a_smooth_line_area_with_region", () => {
        //Given
        var green = Gdk.RGBA() { red = 0.0, green = 1.0, blue = 0.0, alpha = 1.0 };
        var red = Gdk.RGBA() { red = 1.0, green = 0, blue = 0.0, alpha = 1.0 };

        var context = create_context(43, 20);

        var values = new LiveChart.Values();
        values.add({timestamp: (GLib.get_real_time() / 1000) - 7200, value: 5});
        values.add({timestamp: (GLib.get_real_time() / 1000) - 3600, value: 20});
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 5});
       
        var line = new LiveChart.SmoothLineArea(values);
        line.region = new LiveChart.Region.between(3, 10).with_line_color(red);
        line.line.color = green;
        line.area_alpha = 0.5;

        //When
        line.draw(context.ctx, create_config(43, 20));

        //Then the curve colors are...
        assert(get_color_at(context)({x: 0, y: 14}) == red);
        assert(get_color_at(context)({x: 22, y: 0}) == green);
        assert(get_color_at(context)({x: 42, y: 14}) == red);

        //And below the curve, color is...
        var normal_area_color = Gdk.RGBA() { red = 0.5, green = 1, blue = 0.5, alpha = 1 };
        var within_region_area_color = Gdk.RGBA() { red = 1, green = 0.5, blue = 0.5, alpha = 1 };

        assert(get_color_at(context)({x: 0, y: 18}).equal(within_region_area_color));
        assert(get_color_at(context)({x: 22, y: 18}).equal(normal_area_color));
        assert(get_color_at(context)({x: 42, y: 18}).equal(within_region_area_color));
    });    
}