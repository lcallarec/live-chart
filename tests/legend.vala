private void register_legend() {
    Test.add_func("/Legend/draw", () => {
        //Given
        var context = create_context(50, 40);

        var legend = new LiveChart.HorizontalLegend();
        var serie = new LiveChart.Serie("TEST",  new LiveChart.Line());;
        legend.add_legend(serie);
         
        //When
        var config = create_config(context);
        config.width = 20;
        config.height = 20;

        legend.draw(context.ctx, config);
        screenshot(context);

        //Then
        assert(has_only_one_color_in_rectangle(context, 0, 0, 50, 30)(DEFAULT_BACKGROUND_COLOR));

        //there are white and black and lots of grey colors for text "TEST"
        assert(get_colors_in_rectangle(context, 0, 31, 50, 40).size > 1);
    });

    Test.add_func("/Legend/draw_hidden", () => {
        //Given
        var context = create_context(50, 50);

        var legend = new LiveChart.HorizontalLegend();
        var serie = new LiveChart.Serie("TEST",  new LiveChart.Line());
        legend.add_legend(serie);
        legend.visible = false;
         
        //When
        var config = create_config(context);
        config.width = 20;
        config.height = 10;

        legend.draw(context.ctx, config);
        screenshot(context);

        //Then
        assert(has_only_one_color(context)(DEFAULT_BACKGROUND_COLOR));
    });      
}