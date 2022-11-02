using Cairo;

namespace LiveChart { 
    public class Bar : SerieRenderer {
        public Bar(Values values = new Values()) {
            base();
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var points = Points.create(values, config);
                if (points.size > 0) {
                    line.configure(ctx);
                    
                    this.update_bounding_box(points, config);
                    this.debug(ctx);
    
                    for (int pos = 0; pos <= points.size -1; pos++) {
                        var current_point = points.get(pos);
                        var next_point = points.after(pos);
    
                        if (current_point.x < config.padding.left) {
                            continue;
                        }
                        var bar_width = (current_point.x - next_point.x) / 1.2;
                        ctx.rectangle(next_point.x, next_point.y, bar_width, next_point.height);
                    }
                    
                    ctx.fill();
                }
            }
        }

        private void update_bounding_box(Points points, Config config) {
            this.bounding_box = BoundingBox() {
                x=points.first().x,
                y=points.bounds.lower,
                width=points.last().x - points.first().x,
                height=config.boundaries().y.max - points.bounds.lower
            };
        }
    }
}