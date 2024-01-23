private void register_line_area() {
    Test.add_func("/LineArea/should_draw_a_straight_line_area", () => {
        //Given
        var context = create_context();

        var values = new LiveChart.Values();
        //Two points to draw an horizontal line
        values.add({timestamp: (GLib.get_real_time() / 1000) - 10000, value: 5.5});
        values.add({timestamp: (GLib.get_real_time() / 1000), value: 5.5});

        var line = new LiveChart.LineArea(values);
        line.line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        line.area_alpha = 0.5f;

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);

        //Then
        //First fourth row as background
        has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 0);
        has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 1);
        has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 2);
        has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 3);
        //Line
        has_only_one_color_at_row(context)({ 1f, 0f, 0f, 1f }, 4);
        //Area
        has_only_one_color_at_row(context)({ 1f, 1f, 1f, 0.5f }, 0);
        has_only_one_color_at_row(context)({ 1f, 1f, 1f, 0.5f }, 1);
        has_only_one_color_at_row(context)({ 1f, 1f, 1f, 0.5f }, 2);
        has_only_one_color_at_row(context)({ 1f, 1f, 1f, 0.5f }, 3);
    });

    Test.add_func("/LineArea/should_not_render_anything_if_no_values", () => {
        //Given
        var context = create_context();

        var values = new LiveChart.Values();
       
        var line = new LiveChart.LineArea(values);
        line.line.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);
 
        //Then
        assert_true(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });   
}