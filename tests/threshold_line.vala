private void register_threshold_line() {
    Test.add_func("/ThresholdLine", () => {
        //Given
        var red = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        var context = create_context(SURFACE_WIDTH, SURFACE_HEIGHT);

        var line = new LiveChart.ThresholdLine(7.5);
        line.line.color = red;

        //When
        line.draw(context.ctx, create_config(context));
        screenshot(context);

        //Then
        assert(has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 0));
        assert(has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 1));
        
        assert(has_only_one_color_at_row(context)(red, 2));
        
        assert(has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 3));
        assert(has_only_one_color_at_row(context)(DEFAULT_BACKGROUND_COLOR, 4));
    });
}