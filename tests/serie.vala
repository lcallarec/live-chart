
private void register_serie() {

    Test.add_func("/LiveChart/Serie#get_values", () => {
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

    Test.add_func("/LiveChart/Serie#clear", () => {
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
}