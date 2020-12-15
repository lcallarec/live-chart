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
                    area_drawer.draw(ctx, config, points, line, area_alpha);
                }
            }
        }
    }

    public class SmoothLineAreaDrawer : Object {
        private SmoothLineDrawer line_drawer = new SmoothLineDrawer();
        public void draw(Context ctx, Config config, Points points, Path line, double alpha) {
            line_drawer.draw(ctx, config, points, line);
            ctx.stroke_preserve();   
    
            var area = new Area(points, line.color, alpha);
            area.draw(ctx, config);
        }
    }

    public class SmoothLineAreaSerie : TimeSerie {
        private SmoothLineAreaDrawer drawer = new SmoothLineAreaDrawer();
        public double area_alpha {get; set; default = 0.1;}
        public SmoothLineAreaSerie(string name, int buffer_size = 1000) {
            base(name, buffer_size);
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, points_factory.create(config), line, area_alpha);
            }
        }
    }    
}