using LiveChart;

private void register_geometry() {
    Test.add_func("/Geometry/find_intersection_between_two_segments/find_no_intersects_because_colinaear", () => {
        //given
        var s1 = Segment() {
            from = {
                x: 0, 
                y: 0
            },
            to = {
                x: 10,
                y: 10
            }
        };

        var s2 = Segment() {
            from = {
                x: 2, 
                y: 2
            },
            to = {
                x: 3,
                y: 3
            }
        };

        //when 
        var coord = find_intersection_between_two_segments(s1, s2);
        
        //then
        assert(coord == null);
    });

    Test.add_func("/Geometry/find_intersection_between_two_segments/find_no_intersects_because_parallel", () => {
        //given
        var s1 = Segment() {
            from = {
                x: 0, 
                y: 0
            },
            to = {
                x: 10,
                y: 10
            }
        };

        var s2 = Segment() {
            from = {
                x: 5, 
                y: 2
            },
            to = {
                x: 36,
                y: 3
            }
        };

        //when 
        var coord = find_intersection_between_two_segments(s1, s2);
        
        //then
        assert(coord == null);
    });

    Test.add_func("/Geometry/find_intersection_between_two_segments/find_intersects", () => {
        //given
        var s1 = Segment() {
            from = {
                x: 0, 
                y: 0
            },
            to = {
                x: 10,
                y: 10
            }
        };

        var s2 = Segment() {
            from = {
                x: 0, 
                y: 10
            },
            to = {
                x: 10,
                y: 0
            }
        };

        //when 
        var coord = find_intersection_between_two_segments(s1, s2);
        
        //then
        assert(coord == Coord() { x = 5, y = 5 });
    });
}