    using Cairo;
    namespace LiveChart {
        public struct LinearGradient {
            public Gdk.RGBA from;
            public Gdk.RGBA to;
        }

        public struct Coordinate {
            public double x;
            public double y;
        }
        public struct GradientLine {
            public Coordinate from;
            public Coordinate to;
        }

        public class LinearGradientDrawer {
            public void draw(Context ctx, Config config, LinearGradient gradient, GradientLine line) {
               Cairo.Pattern pattern = new Cairo.Pattern.linear(line.from.x, line.from.y, line.to.x, line.to.y);
               pattern.add_color_stop_rgba(0, gradient.from.red, gradient.from.green, gradient.from.blue, gradient.from.alpha);
               pattern.add_color_stop_rgba(1, gradient.to.red, gradient.to.green, gradient.to.blue, gradient.to.alpha);
               ctx.set_source(pattern);
            }
        }
    }