using Cairo;

namespace LiveChart {
    public class SmoothLineArea : SmoothLine {

        public double area_alpha {get; set; default = 0.1;}
        private PointsFactory<TimestampedValue?> points_factory;
        private SmoothLineAreaDrawer area_drawer = new SmoothLineAreaDrawer();

        public SmoothLineArea(Values values = new Values()) {
            base(values);
            points_factory = new TimeStampedPointsFactory(values);
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = points_factory.create(config);
                if(points.size > 0) {
                    area_drawer.draw(points, ctx, config, line, area_alpha);
                }
            }
        }
    }

    public class SmoothLineAreaDrawer : Object {
        private SmoothLineDrawer line_drawer = new SmoothLineDrawer();
        public void draw(Points points, Context ctx, Config config, Path line, double alpha) {
            line_drawer.draw(points, ctx, config, line);
            ctx.stroke_preserve();   
    
            var area = new Area(points, line.color, alpha);
            area.draw(ctx, config);
        }
    }
}