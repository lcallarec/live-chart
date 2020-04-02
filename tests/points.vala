
private void register_points() {

    Test.add_func("/LiveChart/Points#Create", () => {
        //given
        var config = new LiveChart.Config();
        config.width = 100;
        config.height = 100;
        config.padding = { 0, 0, 0, 00 };

        var values = new LiveChart.Values();
        var now = GLib.get_real_time() / 1000;

        values.add({now - 2, 1});
        values.add({now - 1, 10});
        values.add({now, 100});

        //when 
        var points = LiveChart.Points.create(values, config);

        //then
        assert(points.size == values.size);

        var first_point = points.get(0);
        assert((int) first_point.x == 99);
        assert((int) first_point.y == 99);
        assert((int) first_point.height == 1);
        
        var last_point = points.get(2);
        stdout.printf("(int) last_point.x == 100 %f\n", last_point.x);
        assert((int) last_point.x == 100);
        assert((int) last_point.y == 0);
        assert((int) last_point.height == 100);
    });

    Test.add_func("/LiveChart/Points#Create#ShouldntCrashOnEmptyValues", () => {
        //given
        var config = new LiveChart.Config();
        var values = new LiveChart.Values();

        //when //then
        LiveChart.Points.create(values, config);
    });  
}