using Cairo;

namespace LiveChart { 
    public class Bar : SerieRenderer {
        private PointsFactory<TimestampedValue?> points_factory;
        public LinearGradient? gradient;
        private BarDrawer drawer = new BarDrawer();
        public Bar(Values values = new Values()) {
            points_factory = new TimeStampedPointsFactory(values);
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, points_factory.create(config), line, gradient);
            }
        }
    }

    public class BarDrawer : Object {
        public void draw(Context ctx, Config config, Points points, Path line, LinearGradient? gradient) {
            if (points.size > 0) {
                line.configure(ctx);
                for (int pos = 0; pos <= points.size -1; pos++) {
                    var current_point = points.get(pos);
                    var next_point = points.after(pos);

                    if (current_point.x < config.padding.left) {
                        continue;
                    }
                    var bar_width = (current_point.x - next_point.x) / 1.2;
                    ctx.rectangle(next_point.x, next_point.y, bar_width, next_point.height);
                    if (gradient != null) {
                        GradientLine gradient_line = {
                            from : {current_point.x, current_point.y},
                            to: { current_point.x, current_point.y + current_point.height}
                        };
                        new LinearGradientDrawer().draw(ctx, config, gradient, gradient_line);
                        ctx.fill();
                    }
                }
                ctx.fill();
            }
        }

        public BoundingBox get_bounding_box(Points points, Config config) {
            return BoundingBox() {
                x=points.first().x,
                y=points.bounds.lower,
                width=points.last().x - points.first().x,
                height=config.boundaries().y.max - points.bounds.lower
            };
        }
    }
    
    [Version (experimental=true)]
    public class BarSerie : TimeSerie {
        private BarDrawer drawer = new BarDrawer();
        public LinearGradient? gradient;

        public BarSerie(string name, int buffer_size = 1000) {
            base(name, buffer_size);
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, points_factory.create(config), line, gradient);
            }
        }
    }
}