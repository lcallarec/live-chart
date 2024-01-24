
private void register_serie() {

    Test.add_func("/Serie/get_values", () => {
        //given
        var values = new LiveChart.Values();
        values.add({0, 1});
        values.add({1, 10});
        values.add({2, 100});

        var serie = new LiveChart.Serie("Test", new LiveChart.Line(values));

        //when 
        var serie_values = serie.get_values();
        
        //then
        assert(serie_values.size == 3);
    });

    Test.add_func("/Serie/clear", () => {
        //given
        var values = new LiveChart.Values();
        values.add({0, 1});
        values.add({1, 10});
        values.add({2, 100});

        var serie = new LiveChart.Serie("Test", new LiveChart.Line(values));

        //when 
        serie.clear();
        
        //then
        assert(serie.get_values().size == 0);
    });

    Test.add_func("/Chart/#should_not_crash_if_value_added_is_zero", () => {
        //given
        var chart = new LiveChart.Chart();
        var serie = new LiveChart.Serie("Test");
        chart.add_serie(serie);

        //when //then
        serie.add(0);
    });
    
    Test.add_func("/Serie/add_with_timestamp", () => {
        //given
        var serie = new LiveChart.Serie("Test", new LiveChart.Line());

        //when 
        serie.add_with_timestamp(100.0, 5);
        
        //then
        assert(serie.get_values().size == 1);
        assert(serie.get_values().get(0).value == 100.0);
        assert(serie.get_values().get(0).timestamp == 5);
    });    
}