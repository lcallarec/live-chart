
private void register_grid() {

    Test.add_func("/LiveChart/Grid#should_generate_padding_when_y_axis_has_not_unit", () => {
        //given
        var WIDTH = 100;
        var HEIGHT = 100;

        var context = create_context(WIDTH, HEIGHT);

        var config = new LiveChart.Config();
        config.y_axis.update_bounds(10);
        config.height = HEIGHT;
        config.width = WIDTH;
        config.configure(context.ctx, null);
        
        var grid = new LiveChart.Grid();
        var background = new LiveChart.Background();
        background.color = { 1f, 0f, 0f, 1f };
        background.draw(context.ctx, config);

        //when
        grid.draw(context.ctx, config);
        
        //then
        var pixbuff = Gdk.pixbuf_get_from_surface(context.surface, 0, 0, WIDTH, HEIGHT);

        //Colors between left side and first pixels of "0" char on y-axis
        var padding_colors = colors_at(pixbuff, WIDTH, HEIGHT)(0, 80, 10, 80);
        assert(padding_colors.size == 11);
        foreach (var color in padding_colors) {
            assert(color.red == 1.0);
            assert(color.green == 0);
            assert(color.blue == 0);
            assert(color.alpha == 1);
        }
    });
}

