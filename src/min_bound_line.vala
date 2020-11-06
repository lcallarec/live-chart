using Cairo;

namespace LiveChart { 
    
    public class MinBoundLine : SerieRenderer {
        
        public MinBoundLine(Values? values = null) {
            base();
            this.values = values;
        }

        public MinBoundLine.from_serie(Serie serie) {
            this.values = serie.get_values();
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var boundaries = config.boundaries();
                var y = values == null ? config.y_axis.get_bounds().lower * config.y_axis.get_ratio() : values.bounds.lower * config.y_axis.get_ratio();
                line.configure(ctx);
                ctx.move_to((double) boundaries.x.min, boundaries.y.max - y);
                ctx.line_to((double) boundaries.x.max, boundaries.y.max - y);
                ctx.stroke();
            }
        }
    }
}