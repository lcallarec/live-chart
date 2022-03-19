private LiveChart.TimestampedValue get_at(int index, LiveChart.Values values){
    assert(values.size < index);
    assert(index >= 0);
    
    LiveChart.TimestampedValue ret = {};
    int i = 0;
    
    values.foreach((v) => {
        if(i == index){
            ret = v;
            return false;
        }
        return true;
    });
    return ret;
}
private void register_chart() {

    Test.add_func("/LiveChart/Chart/serie/add_value#should_update_bounds_when_adding_a_value", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when //then
        assert_false(chart.config.y_axis.get_bounds().has_upper());

        //when
        serie.add(100.0);

        //then
        assert(chart.config.y_axis.get_bounds().upper == 100.0);
    });

    //Deprecated
    Test.add_func("/LiveChart/Chart/add_value#should_update_bounds_when_adding_a_value", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when //then
        assert_false(chart.config.y_axis.get_bounds().has_upper());

        //when
        chart.add_value(serie, 100.0);

        //then
        assert(chart.config.y_axis.get_bounds().upper == 100.0);
    });

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
        /*
        assert(serie.get_values().get(0).value == 5);
        assert(serie.get_values().get(1).value == 10);
        assert(serie.get_values().get(2).value == 15);
        assert(serie.get_values().get(2).timestamp == now);
        assert(serie.get_values().get(1).timestamp == now - 5000);
        assert(serie.get_values().get(0).timestamp == now - 10000);
        */
        assert(get_at(0, serie.get_values()).value == 5);
        assert(get_at(1, serie.get_values()).value == 10);
        assert(get_at(2, serie.get_values()).value == 15);
        assert(get_at(2, serie.get_values()).timestamp == now);
        assert(get_at(1, serie.get_values()).timestamp == now - 5000);
        assert(get_at(0, serie.get_values()).timestamp == now - 10000);
        assert(chart.config.y_axis.get_bounds().lower == 5);
        assert(chart.config.y_axis.get_bounds().upper == 15);
    });

    Test.add_func("/LiveChart/Chart/serie/add_value_by_index", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when
        try {
            chart.series[0].add(100);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }

        //then
        assert(serie.get_values().size == 1);
        assert(serie.get_values().first().value == 100);
    });

    //Deprecated
    Test.add_func("/LiveChart/Chart/add_value_by_index", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("TEST");
        
        chart.add_serie(serie);
        
        //when
        try {
            chart.add_value_by_index(0, 100);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }

        //then
        assert(serie.get_values().size == 1);
        assert(serie.get_values().first().value == 100);
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
        try {
            chart.add_unaware_timestamp_collection_by_index(0, unaware_timestamp_collection, timespan_between_value);
        } catch (LiveChart.ChartError e) {
            assert_not_reached();
        }

        //then
        assert(serie.get_values().size == 3);
/*
        assert(serie.get_values().get(0).value == 5);
        assert(serie.get_values().get(1).value == 10);
        assert(serie.get_values().get(2).value == 15);
        assert(serie.get_values().get(2).timestamp == now);
        assert(serie.get_values().get(1).timestamp == now - 5000);
        assert(serie.get_values().get(0).timestamp == now - 10000);
*/
        assert(get_at(0, serie.get_values()).value == 5);
        assert(get_at(1, serie.get_values()).value == 10);
        assert(get_at(2, serie.get_values()).value == 15);
        assert(get_at(2, serie.get_values()).timestamp == now);
        assert(get_at(1, serie.get_values()).timestamp == now - 5000);
        assert(get_at(0, serie.get_values()).timestamp == now - 10000);
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

        Test.add_func("/LiveChart/Chart/background#main_color_should_be_accessible_even_if_deprected", () => {
        //given
        var chart = new LiveChart.Chart();

        //when
        chart.background.main_color = {1, 1, 1, 1};
       
        //then
        //ok
        
    });
}
