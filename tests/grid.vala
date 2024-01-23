
private void register_grid() {

    Test.add_func("/Grid/should_generate_padding_when_y_axis_has_not_unit", () => {
        //given
        var WIDTH = 100;
        var HEIGHT = 100;

        var red = Gdk.RGBA() { red = 1f, green = 0f, blue = 0f, alpha = 1f };

        var context = create_context(WIDTH, HEIGHT);
        context.set_background_color(red);

        var config = new LiveChart.Config();
        config.height = HEIGHT;
        config.width = WIDTH;
        config.configure(context.ctx, null);
        
        var grid = new LiveChart.Grid();

        //when
        grid.draw(context.ctx, config);
        screenshot(context);

        //then
        //Colors between left side and first pixels of "0" char on y-axis
        assert(has_only_one_color_in_rectangle(context, 0, 80, 10, 80)(red));
    });
}

