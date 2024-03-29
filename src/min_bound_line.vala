using Cairo;

namespace LiveChart { 
    
    public class MinBoundLine : SerieRenderer {
        
        private MinBoundLineDrawer drawer = new MinBoundLineDrawer();

        public MinBoundLine(Values values = new Values()) {
            base();
            this.values = values;
        }

        public MinBoundLine.from_serie(Serie serie) {
            this.values = serie.get_values();
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, this.line, this.values);
            }
        }
    }

    public class MinBoundLineDrawer {
        public void draw(Context ctx, Config config, Path line, Values values) {
            var boundaries = config.boundaries();
            var y = values.size == 0 ? config.y_axis.get_bounds().lower * config.y_axis.get_ratio() : values.bounds.lower * config.y_axis.get_ratio();
            line.configure(ctx);
            ctx.move_to((double) boundaries.x.min, boundaries.y.max - y);
            ctx.line_to((double) boundaries.x.max, boundaries.y.max - y);
            ctx.stroke();
        }
    }
}