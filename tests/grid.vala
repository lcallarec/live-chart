
private void register_grid() {

    Test.add_func("/LiveChart/Grid#should_generate_padding_when_y_axis_has_not_unit", () => {
        //given
        var WIDTH = 100;
        var HEIGHT = 100;

        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, WIDTH, HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);

        var config = new LiveChart.Config();
        config.y_axis.update_bounds(10);
        config.height = HEIGHT;
        config.width = WIDTH;
        config.configure(context, null);
        
        var grid = new LiveChart.Grid();
        var background = new LiveChart.Background();
        background.color = {1, 0, 0, 1};
        background.draw(context, config);

        //when
        grid.draw(context, config);

        //then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, WIDTH, HEIGHT);

        //Colors between left side and first pixels of "0" char on y-axis
        var padding_colors = colors_at(pixbuff)(0, 80, 10, 80);
        assert(padding_colors.size == 11);
        foreach (var color in padding_colors) {
            assert(color.red == 1.0);
            assert(color.green == 0);
            assert(color.blue == 0);
            assert(color.alpha == 1);
        }
    });

    Test.add_func("/LiveChart/Grid/draw#gradient", () => {
        //Given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, 10, 10);
        Cairo.Context context = new Cairo.Context(surface);
        cairo_background(context);

        var grid = new LiveChart.Grid();
        grid.visible = false;
        grid.gradient = {from: red(), to: green()};

        //When
        grid.draw(context, create_config(10, 10));
 
        //Then
        var pixbuff = Gdk.pixbuf_get_from_surface(surface, 0, 0, 10, 10);
        if (pixbuff != null) {
            var at = color_at(pixbuff);
            assert(at(0, 0).to_string() == "rgb(242,13,0)");
            assert(at(0, 9).to_string() == "rgb(13,242,0)");            
        } else {
            assert_not_reached();
        }
    });   
}

