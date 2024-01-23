namespace LiveChart {
    public struct Coord {
        double x;
        double y;
    }

    public struct Segment {
        Coord from;
        Coord to;
    }

    //https://github.com/psalaets/line-intersect
    public Coord? find_intersection_between_two_segments(Segment s1, Segment s2) {
    
        var denom = ((s2.to.y - s2.from.y) * (s1.to.x - s1.from.x)) - ((s2.to.x - s2.from.x) * (s1.to.y - s1.from.y));
        var numeA = ((s2.to.x - s2.from.x) * (s1.from.y - s2.from.y)) - ((s2.to.y - s2.from.y) * (s1.from.x - s2.from.x));
        var numeB = ((s1.to.x - s1.from.x) * (s1.from.y - s2.from.y)) - ((s1.to.y - s1.from.y) * (s1.from.x - s2.from.x));
        
        if (denom == 0 || ((numeA == 0 && numeB == 0))) {
            return null;
        }
        
        var uA = numeA / denom;
        var uB = numeB / denom;
        
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
            return {
                x: s1.from.x + (uA * (s1.to.x - s1.from.x)),
                y: s1.from.y + (uA * (s1.to.y - s1.from.y))
            };
        }
        
        return null;
    }
}