using Cairo;

namespace LiveChart { 
    
    public class MaxBoundLine : SerieRenderer {
        
        public MaxBoundLine() {
            base();
            this.values = new Values();
        }

        public MaxBoundLine.from_serie(Serie serie) {
            this.values = serie.get_values();
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var boundaries = config.boundaries();
                var y = values.size == 0 ? config.y_axis.get_bounds().upper * config.y_axis.get_ratio() : values.bounds.upper * config.y_axis.get_ratio();
                line.configure(ctx);
                ctx.move_to((double) boundaries.x.min, boundaries.y.max - y);
                ctx.line_to((double) boundaries.x.max, boundaries.y.max - y);
                ctx.stroke();
            }
        }
    }
}