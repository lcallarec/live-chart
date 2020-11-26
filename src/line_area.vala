using Cairo;

namespace LiveChart { 
    public class LineArea : Line {

        public double area_alpha {get; set; default = 0.1;}
        private PointsFactory<TimestampedValue?> points_factory;
        private LineAreaDrawer area_drawer = new LineAreaDrawer();

        public LineArea(Values values = new Values()) {
            base(values);
            points_factory = new TimeStampedPointsFactory(values);
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = points_factory.create(config);
                if (points.size > 0) {
                    area_drawer.draw(points, ctx, config, line, area_alpha);
                }
                //Avoid side-effects
                ctx.stroke();
            }
        }
    }

    public class LineAreaDrawer : Object {
        private LineDrawer line_drawer = new LineDrawer();
        public void draw(Points points, Context ctx, Config config, Path line, double alpha) {
            line_drawer.draw_line(points, ctx, config, line);
            ctx.stroke_preserve();   
    
            var area = new Area(points, line.color, alpha);
            area.draw(ctx, config);
        }
    }
}