using Cairo;

namespace LiveChart { 
    public class Bar : DrawableSerie {
        public Bar(Values values = new Values()) {
            this.values = values;
        }

        public override void draw(Context ctx, Config config) {
            var points = Points.create(values, config);
            if (points.size > 0) {
                ctx.set_source_rgba(this.main_color.red, this.main_color.green, this.main_color.blue, this.main_color.alpha);
                ctx.set_line_width(this.outline_width);
                
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