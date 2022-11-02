private void register_area() {
    Test.add_func("/Area/should_not_render_anything_when_there_are_no_values_yet", () => {
        //Given
        var context = create_context();

        var points = LiveChart.Points.create(new LiveChart.Values(), create_config());
       
        var red = Gdk.RGBA() {red = 1.0f, green = 0.0f, blue = 0.0f, alpha = 1.0f };
        var area = new LiveChart.Area(points, red, 1.0);

        //When
        area.draw(context.ctx, create_config());
 
        //Then
        assert(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });
}