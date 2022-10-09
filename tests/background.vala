private void register_background() {
    Test.add_func("/Background/should_draw_a_background_of_specified_color", () => {
        //Given
        var context = create_context();

        var back = new LiveChart.Background();
        back.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };

        //When
        back.draw(context.ctx, create_config());
 
        //Then
        assert(has_only_one_color(context)(back.color));
    });

    Test.add_func("/Background/should_not_draw_background_when_it_is_hidden", () => {
        //Given
        var context = create_context();

        var back = new LiveChart.Background();
        back.color = Gdk.RGBA() {red = 1.0, green = 0.0, blue = 0.0, alpha = 1.0 };
        back.visible = false;

        //When
        back.draw(context.ctx, create_config());
 
        //Then
        assert(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });    
}