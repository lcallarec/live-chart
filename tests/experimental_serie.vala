[Version (experimental=true)]
private void register_experimental_serie() {

    Test.add_func("/LiveChart/TimeSerie/get_values", () => {
        //given
        var serie = new LiveChart.LineSerie("Test");
        serie.add(1);
        serie.add(2);
        serie.add(10);

        //when 
        var serie_values = serie.get_values();
        
        //then
        assert(serie_values.size == 3);
    });

    Test.add_func("/LiveChart/TimeSerie/clear", () => {
        //given
        var serie = new LiveChart.LineSerie("Test");
        serie.add(1);
        serie.add(2);
        serie.add(10);

        //when 
        serie.clear();
        
        //then
        assert(serie.get_values().size == 0);
    });

    Test.add_func("/LiveChart/TimeChart/#should_not_crash_if_value_added_is_zero", () => {
        //given
        var chart = new LiveChart.TimeChart();
        var serie = new LiveChart.LineSerie("Test");
        chart.add_serie(serie);

        //when //then
        serie.add(0);
    });
    
    Test.add_func("/LiveChart/TimeSerie/add_with_timestamp", () => {
        //given
        var serie = new LiveChart.LineSerie("Test");

        //when 
        serie.add_with_timestamp(100.0, 5);
        
        //then
        assert(serie.get_values().size == 1);
        assert(serie.get_values().get(0).value == 100.0);
        assert(serie.get_values().get(0).timestamp == 5);
    });    
}