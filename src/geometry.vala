namespace LiveChart {
    public struct Coord {
        double x;
        double y;
    }

    public struct Segment {
        Coord from;
        Coord to;
    }
    public struct BezierCurve {
        Coord c0;
        Coord c1;
        Coord c2;
        Coord c3;
    }

    public BezierCurve build_bezier_curve_from_points(Point previous, Point target) {
        var pressure = (target.x - previous.x) / 2.0;
        BezierCurve bezier = {
            c0: {
                x: previous.x,
                y: previous.y
            },
            c1: {
                x: previous.x + pressure,
                y: previous.y
            },
            c2: {
                x: target.x - pressure,
                y: target.y
            },
            c3: {
                x: target.x,
                y: target.y
            }
        };

        return bezier;
    } 
}