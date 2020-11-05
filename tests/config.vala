
private void register_config() {

    Test.add_func("/LiveChart/Config#Boundaries", () => {
        //given
        var config = new LiveChart.Config();
        config.width = 100;
        config.height = 200;
        config.padding = { smart: LiveChart.AutoPadding.NONE, 20, 25, 10, 30 };

        //when 
        var boundaries = config.boundaries();
        
        //then
        assert(boundaries.x.min == 30);
        assert(boundaries.x.max == 75);
        assert(boundaries.y.min == 20);
        assert(boundaries.y.max == 190);
        assert(boundaries.width == 45);
        assert(boundaries.height == 170);        
    });

    Test.add_func("/LiveChart/Config#AxisTextExtentsWithoutNoVisibleLabels", () => {
        //given
        Cairo.ImageSurface surface = new Cairo.ImageSurface(Cairo.Format.ARGB32, SURFACE_WIDTH, SURFACE_HEIGHT);
        Cairo.Context context = new Cairo.Context(surface);

        var config = new LiveChart.Config();
        config.y_axis.visible = false;
      
        //when 
        config.configure(context, null);
        
        //then
        assert(config.y_axis.labels.extents.height == 0);
        assert(config.y_axis.labels.extents.width == 0);
        assert(config.y_axis.labels.extents.x_advance == 0);
        assert(config.y_axis.labels.extents.x_bearing == 0);
        assert(config.y_axis.labels.extents.y_advance == 0);
        assert(config.y_axis.labels.extents.y_bearing == 0);
    });
}