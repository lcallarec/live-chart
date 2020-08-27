
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

    Test.add_func("/LiveChart/Chart/add_unaware_timestamp_collection", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");

        var unaware_timestamp_collection = new Gee.ArrayList<double?>();
        unaware_timestamp_collection.add(5);
        unaware_timestamp_collection.add(10);
        unaware_timestamp_collection.add(15);

        var timespan_between_value = 5000;

        //when
        var now = GLib.get_real_time() / 1000;
        chart.add_unaware_timestamp_collection(serie, unaware_timestamp_collection, timespan_between_value);

        //then
        assert(serie.get_values().size == 3);
        assert(serie.get_values().get(0).value == 5);
        assert(serie.get_values().get(1).value == 10);
        assert(serie.get_values().get(2).value == 15);
        assert(serie.get_values().get(2).timestamp == now);
        assert(serie.get_values().get(1).timestamp == now - 5000);
        assert(serie.get_values().get(0).timestamp == now - 10000);

        assert(chart.config.y_axis.get_bounds().lower == 5);
        assert(chart.config.y_axis.get_bounds().upper == 15);
    });

    Test.add_func("/LiveChart/Chart/add_value_by_index", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when
        chart.add_value_by_index(0, 100);

        //then
        assert(serie.get_values().size == 1);
        assert(serie.get_values().get(0).value == 100);
    });   


    Test.add_func("/LiveChart/Chart/add_unaware_timestamp_collection_by_index", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        var unaware_timestamp_collection = new Gee.ArrayList<double?>();
        unaware_timestamp_collection.add(5);
        unaware_timestamp_collection.add(10);
        unaware_timestamp_collection.add(15);

        var timespan_between_value = 5000;

        //when
        var now = GLib.get_real_time() / 1000;
        chart.add_unaware_timestamp_collection_by_index(0, unaware_timestamp_collection, timespan_between_value);

        //then
        assert(serie.get_values().size == 3);
        assert(serie.get_values().get(0).value == 5);
        assert(serie.get_values().get(1).value == 10);
        assert(serie.get_values().get(2).value == 15);
        assert(serie.get_values().get(2).timestamp == now);
        assert(serie.get_values().get(1).timestamp == now - 5000);
        assert(serie.get_values().get(0).timestamp == now - 10000);

        assert(chart.config.y_axis.get_bounds().lower == 5);
        assert(chart.config.y_axis.get_bounds().upper == 15);
    });   

    Test.add_func("/LiveChart/Chart/#ShouldNotCrashWhenRevealingAChartWithoutAnyValueAdded", () => {
        //given
        var chart = new LiveChart.Chart();
        chart.add_serie(new LiveChart.Serie("Test"));
       
        //when
        //then
        Timeout.add(1000, () => {
            Gtk.main_quit();
            return false;
        });
        Gtk.main();
    });
}
