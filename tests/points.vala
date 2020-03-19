
private void register_points() {

    Test.add_func("/LiveChart/Points#Create", () => {
        //given
        var geometry = new LiveChart.Geometry();
        geometry.width = 100;
        geometry.height = 100;
        geometry.padding = { 0, 0, 0, 00 };

        var values = new LiveChart.Values();
        var now = GLib.get_real_time() / 1000;

        values.add({now - 2, 1});
        values.add({now - 1, 10});
        values.add({now, 100});

        //when 
        var points = LiveChart.Points.create(values, geometry);

        //then
        assert(points.size == values.size);

        var first_point = points.get(0);
        assert((int) first_point.x == 99);
        assert((int) first_point.y == 99);
        assert((int) first_point.height == 1);
        
        var last_point = points.get(2);
        assert((int) last_point.x == 100);
        assert((int) last_point.y == 00);
        assert((int) last_point.height == 100);
    });
}