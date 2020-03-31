
private void register_chart() {

    Test.add_func("/LiveChart/Chart#Export", () => {
        //given
        var window = new Gtk.Window();
        var chart = new LiveChart.Chart();
        window.add(chart);
        window.show();
        window.resize(50, 50);
        chart.show_all();
 
        //when
        try {
            chart.to_png("export.png");
        } catch (Error e) {
            assert_not_reached() ;
        }
        
        //then
        File file = File.new_for_path("export.png");
        assert(true == file.query_exists());
    });

    Test.add_func("/LiveChart/Chart#ExportWhenNotRealized", () => {
        //given
        var chart = new LiveChart.Chart();

        //when //then
        try {
            chart.to_png("export.png");
            assert_not_reached();
        } catch (Error e) {
            assert(e is LiveChart.ChartError.EXPORT_ERROR);
        }
    });

    Test.add_func("/LiveChart/Chart#UpdateBounds", () => {
        //given
        var config = new LiveChart.Config();
        var chart = new LiveChart.Chart(config);

        var serie = new LiveChart.Serie("TEST", new LiveChart.SmoothLineArea());
        chart.add_serie(serie);
        
        //when
        chart.add_value(serie, 0.0354);

        //then
        assert(config.y_axis.get_bounds().lower == 0.0354);
        assert(config.y_axis.get_bounds().upper == 0.0354);
        
        //when
        chart.add_value(serie, 0.0302);

        //then
        assert(config.y_axis.get_bounds().lower == 0.0302);
        assert(config.y_axis.get_bounds().upper == 0.0354);        
    });    
}
