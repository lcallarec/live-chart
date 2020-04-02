using Cairo;

namespace LiveChart {

    public class Grid : Drawable, Object {
        private const int ABSCISSA_TIME_PADDING = 14;
        protected BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        
        public Gdk.RGBA main_color { 
            get; set; default= Gdk.RGBA() {
                red = 0.5,
                green = 0.5,
                blue = 0.5,
                alpha = 1.0
            };
        }

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

        protected void render_abscissa(Context ctx, Config config) {
            ctx.set_source_rgba(this.main_color.red, this.main_color.green, this.main_color.blue, this.main_color.alpha);
            ctx.set_line_width(0.5);
            
            ctx.move_to(config.padding.left + 0.5, config.height - config.padding.bottom + 0.5);
            ctx.line_to(config.width - config.padding.right + 0.5, config.height - config.padding.bottom + 0.5);
            ctx.stroke();       
        }

        protected void render_ordinate(Context ctx, Config config) {
            ctx.set_source_rgba(0.5, 0.5, 0.5, 1.0);
            ctx.set_line_width(0.5);

            ctx.move_to(config.padding.left + 0.5, config.height - config.padding.bottom + 0.5);
            ctx.line_to(config.padding.left + 0.5, config.padding.top + 0.5);
            ctx.stroke();
        }

        protected void render_grid(Context ctx, Config config) {
            ctx.set_source_rgba(0.4, 0.4, 0.4, 1.0);

            this.render_hgrid(ctx, config);
            this.render_vgrid(ctx, config);
        }

        protected void render_vgrid(Context ctx, Config config) {
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
                time -= (int) config.x_axis.tick_interval;
            }
            ctx.stroke();
            ctx.set_dash(null, 0.0);           
        }

        protected void render_hgrid(Context ctx, Config config) {
            var boundaries = config.boundaries();
            foreach(float position in config.y_axis.ticks.values) {
                ctx.set_dash({5.0}, 0);

                var y = boundaries.height + boundaries.y.min - position * config.y_axis.get_ratio();
                ctx.move_to(0.5 + boundaries.x.max, y + 0.5);
                ctx.line_to(boundaries.x.min + 0.5, y + 0.5);

                var value = format_for_y_axis(config.y_axis.unit, position);

                TextExtents extents;
                ctx.text_extents(value, out extents);
                ctx.move_to(boundaries.x.min - extents.width - 5, y + (extents.height / 2) + 0.5);
                ctx.show_text(value);

                config.y_axis.displayed_values.add(value);
            }

            ctx.stroke();
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
    }
}