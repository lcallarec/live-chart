
private void register_grid() {

    Test.add_func("/LiveChart/Grid#config_max_displayed_value", () => {
        //given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, 100, 100);
        Cairo.Context context = new Cairo.Context(surface);

        var config = new LiveChart.Config();
        config.y_axis.update_bounds(95.0);
        config.padding = { smart: null, 0, 0, 0, 0 };
        config.height = 100;
        config.width = 100;
        config.configure(context, null);
        
        var grid = new LiveChart.Grid();

        //when

        grid.draw(context, config);

        //then
        assert(config.y_axis.get_max_displayed_value() == "100");
    });
}
