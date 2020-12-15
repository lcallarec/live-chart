using Cairo;

namespace LiveChart { 
    public class SmoothLine : SerieRenderer {
        private SmoothLineDrawer drawer = new SmoothLineDrawer();
        private PointsFactory<TimestampedValue?> points_factory;

        public SmoothLine(Values values = new Values()) {
            points_factory = new TimeStampedPointsFactory(values);
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = points_factory.create(config);
                if(points.size > 0) {
                    draw_smooth_line(ctx, config, points, line);
                    ctx.stroke();
                }            
            }
        }

        public void draw_smooth_line(Context ctx, Config config, Points points, Path line) {
            if(points.size > 0) {
                drawer.draw(ctx, config, points, line);
            }
        }
    }

    public class SmoothLineDrawer : Object {
        public void draw(Context ctx, Config config, Points points, Path line) {
            if(points.size > 0) {
                line.configure(ctx);
                
                var first_point = points.first();
                ctx.move_to(first_point.x, first_point.y);
                for (int pos = 0; pos <= points.size -1; pos++) {
                    var previous_point = points.get(pos);
                    var target_point = points.after(pos);
                    var pressure = (target_point.x - previous_point.x) / 2.0;

                    if (is_out_of_area(previous_point)) {
                        continue;
                    }

                    ctx.curve_to(
                        previous_point.x + pressure, previous_point.y,
                        target_point.x - pressure, target_point.y, 
                        target_point.x, target_point.y
                    );
                }
            }
        }
        
        public BoundingBox get_bounding_box(Points points, Config config) {
            return BoundingBox() {
                x=points.first().x,
                y=points.bounds.lower,
                width=points.last().x - points.first().x,
                height=points.bounds.upper - points.bounds.lower
            };
        }
    }

    [Version (experimental=true)]
    public class SmoothLineSerie : TimeSerie {
        private SmoothLineDrawer drawer = new SmoothLineDrawer();

        public SmoothLineSerie(string name, int buffer_size = 1000) {
            base(name, buffer_size);
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, points_factory.create(config), line);
            }
        }
    }
}