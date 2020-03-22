using Cairo;

namespace LiveChart {

    public abstract class Grid : Drawable, Object {
        private const int ABSCISSA_TIME_PADDING = 14;
        public string unit {
            get; set construct;
        }
        protected BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };

        public void draw(Context ctx, Config config) {
            this.render_abscissa(ctx, config);
            this.render_ordinate(ctx, config);            
            this.render_grid(ctx, config);
            this.update_bounding_box(config);
            this.debug(ctx);
        }

        public BoundingBox get_bounding_box() {
            return this.bounding_box;
        }

        protected virtual void render_abscissa(Context ctx, Config config) {
            ctx.set_source_rgba(0.5, 0.5, 0.5, 1.0);
            ctx.set_line_width(0.5);
            
            ctx.move_to(config.padding.left + 0.5, config.height - config.padding.bottom + 0.5);
            ctx.line_to(config.width - config.padding.right + 0.5, config.height - config.padding.bottom + 0.5);
            ctx.stroke();       
        }

        protected virtual void render_ordinate(Context ctx, Config config) {
            ctx.set_source_rgba(0.5, 0.5, 0.5, 1.0);
            ctx.set_line_width(0.5);

            ctx.move_to(config.padding.left + 0.5, config.height - config.padding.bottom + 0.5);
            ctx.line_to(config.padding.left + 0.5, config.padding.top + 0.5);
            ctx.stroke();
        }

        protected virtual void render_grid(Context ctx, Config config) {
            ctx.set_source_rgba(0.4, 0.4, 0.4, 1.0);

            this.render_hgrid(ctx, config);
            this.render_vgrid(ctx, config);
        }

        protected virtual void render_vgrid(Context ctx, Config config) {
            var time = new DateTime.now().to_unix();
            ctx.set_dash({5.0}, 0);
            
            for (double i = config.width - config.padding.right; i > config.padding.left; i -= config.x_axis.tick_length) {
                ctx.move_to(i + 0.5, 0.5 + config.height - config.padding.bottom);
                ctx.line_to(i + 0.5, 0.5 + config.padding.top);
                
                // Values
                var text = new DateTime.from_unix_local(time).format("%H:%M:%S");
                TextExtents extents;
                ctx.text_extents(text, out extents);
                
                ctx.move_to(i + 0.5 - extents.width / 2, 0.5 + config.height - config.padding.bottom + Grid.ABSCISSA_TIME_PADDING);
                ctx.show_text(text);
                time -= config.x_axis.tick_interval;
            }
            ctx.stroke();
            ctx.set_dash(null, 0.0);           
        }

        protected void update_bounding_box(Config config) {
            var boundaries = config.boundaries();
            this.bounding_box = BoundingBox() {
                x=boundaries.x.min,
                y=boundaries.y.min,
                width=boundaries.x.max - boundaries.x.min, 
                height=boundaries.y.max - boundaries.y.min + Grid.ABSCISSA_TIME_PADDING
            };
        }
        protected void debug(Context ctx) {
            var debug = Environment.get_variable("LIVE_CHART_DEBUG");
            if(debug != null) {
                ctx.rectangle(bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height);
                ctx.stroke();
            }
        }    
        protected abstract void render_hgrid(Context ctx, Config config);
    }

    public class FixedTickIntervalGrid : Grid {

        private int steps;
        public FixedTickIntervalGrid(string unit = "",int steps = 20) {
            this.unit = unit;
            this.steps = steps;
        }
   
        protected override void render_hgrid(Context ctx, Config config) {
            var y_scaled_pos = 0.0;
            for (double i = config.height - config.padding.bottom; i > config.padding.top; i -= steps * config.y_axis.get_ratio()) {

                if (i < config.padding.top) {
                    break;
                }
                ctx.set_dash({5.0}, 0);
                ctx.move_to(0.5 + config.width - config.padding.right, i + 0.5);
                ctx.line_to(config.padding.left + 0.5, i + 0.5);

                //Values
                var s = @"$y_scaled_pos" + unit;
                TextExtents extents;
                ctx.text_extents(s, out extents);
                ctx.move_to(config.padding.left - extents.width - 5, i + 0.5);
                ctx.show_text(s);
                y_scaled_pos += steps;
            }
            ctx.stroke();            
        }
    }

    public class WIPFixedDistanceGrid : Grid {

        private int distance;
        public WIPFixedDistanceGrid(string unit = "",int distance = 20) {
            this.unit = unit;
            this.distance = distance;
        }
   
        protected override void render_hgrid(Context ctx, Config config) {
            var y_scaled_pos = 0.0;
            for (double i = config.height - config.padding.bottom; i > config.padding.top; i -= this.distance) {

                if (i < config.padding.top) {
                    break;
                }
                ctx.set_dash({5.0}, 0);
                ctx.move_to(0.5 + config.width - config.padding.right, i + 0.5);
                ctx.line_to(config.padding.left + 0.5, i + 0.5);

                //Values
                var s = @"$y_scaled_pos" + unit;
                TextExtents extents;
                ctx.text_extents(s, out extents);
                ctx.move_to(config.padding.left - extents.width - 5, i + 0.5);
                ctx.show_text(s);
                y_scaled_pos += (config.height / (int) config.y_axis.get_bounds().upper) * this.distance;
            }
            ctx.stroke();            
        }
    }
}