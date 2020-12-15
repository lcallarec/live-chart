using Cairo;

namespace LiveChart { 
    public class StraightLineDrawer {
        public void draw(Context ctx, Config config, Path line, double at_value) {
            var boundaries = config.boundaries();
            var y = at_value * config.y_axis.get_ratio();
            line.configure(ctx);
            ctx.move_to((double) boundaries.x.min, boundaries.y.max - y);
            ctx.line_to((double) boundaries.x.max, boundaries.y.max - y);
            ctx.stroke();
        }
    }
    public class MaxBoundLine : SerieRenderer {
        private StraightLineDrawer drawer = new StraightLineDrawer();
        public MaxBoundLine() {
            this.values = new Values();
        }

        public MaxBoundLine.from_serie(Serie serie) {
            this.values = serie.get_values();
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var at_value = values.size == 0 ? config.y_axis.get_bounds().upper : values.bounds.upper;
                drawer.draw(ctx, config, line, at_value);
            }
        }
    }
    
    public class MinBoundLine : SerieRenderer {
        private StraightLineDrawer drawer = new StraightLineDrawer();
        public MinBoundLine(Values values = new Values()) {
            this.values = values;
        }

        public MinBoundLine.from_serie(Serie serie) {
            this.values = serie.get_values();
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var at_value = values.size == 0 ? config.y_axis.get_bounds().lower : values.bounds.lower;
                drawer.draw(ctx, config, line, at_value);
            }
        }
    }

    public class ThresholdLine : SerieRenderer {
        private StraightLineDrawer drawer = new StraightLineDrawer();
        public double value { get; set; default = 0;}
        
        public ThresholdLine(double value) {
            this.value = value;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, line, value);
            }
        }
    }

    public class MaxBoundLineSerie : TimeSerie {
        private StraightLineDrawer drawer = new StraightLineDrawer();
        
        public MaxBoundLineSerie(string name) {
            base(name, 1);
        }

        public MaxBoundLineSerie.from_serie(string name, TimeSerie serie) {
            base(name, 1);
            this.values = serie.get_values();
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var at_value = values.size == 0 ? config.y_axis.get_bounds().upper : values.bounds.upper;
                drawer.draw(ctx, config, line, at_value);
            }
        }
    }

    public class MinBoundLineSerie : TimeSerie {
        private StraightLineDrawer drawer = new StraightLineDrawer();
        
        public MinBoundLineSerie(string name) {
            base(name, 1);
        }

        public MinBoundLineSerie.from_serie(string name, TimeSerie serie) {
            base(name, 1);
            this.values = serie.get_values();
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                var at_value = values.size == 0 ? config.y_axis.get_bounds().lower : values.bounds.lower;
                drawer.draw(ctx, config, line, at_value);
            }
        }
    }

    public class ThresholdLineSerie : TimeSerie {
        public double at_value { get; set; default = 0;}

        private StraightLineDrawer drawer = new StraightLineDrawer();

        public ThresholdLineSerie(string name, double at_value) {
            base(name, 1);
            this.at_value = at_value;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                drawer.draw(ctx, config, line, at_value);
            }
        }
    }    
}