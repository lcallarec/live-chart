private void register_background() {
    Test.add_func("/Background/should_draw_a_background_of_specified_color", () => {
        //Given
        var context = create_context();

        var back = new LiveChart.Background();
        back.color = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        //When
        back.draw(context.ctx, create_config(context));
        screenshot(context);

        //Then
        assert(has_only_one_color(context)(back.color));
    });

    Test.add_func("/Background/should_not_draw_background_when_it_is_hidden", () => {
        //Given
        var white = Gdk.RGBA() {red = 1.0f, green = 1.0f, blue = 1.0f, alpha = 1.0f };
        var red = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };

        var context = create_context();
        context.set_background_color(white);

        var back = new LiveChart.Background();
        back.color = red;
        back.visible = false;

        //When
        back.draw(context.ctx, create_config(context));
        screenshot(context);

        //Then
        assert(has_only_one_color(context)(white));
    });    
}