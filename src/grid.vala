using Cairo;

namespace LiveChart {

    public class Grid : Drawable, Object {
        public const int ABSCISSA_TIME_PADDING = 5;
        protected BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        
        public bool visible { get; set; default = true; }
        public Gdk.RGBA main_color { 
            get; set; default= Gdk.RGBA() {
                red = 0.4,
                green = 0.4,
                blue = 0.4,
                alpha = 1.0
            };
        }

        public LinearGradient? gradient { get; set; }

        public void draw(Context ctx, Config config) {
            render_background(ctx, config);
            if (visible) {
                render_abscissa(ctx, config);
                render_ordinate(ctx, config);            
                render_grid(ctx, config);
                
                update_bounding_box(config);
            }
        }

        public BoundingBox get_bounding_box() {
            return this.bounding_box;
        }

        protected void restore(Context ctx) {
            ctx.set_source_rgba(this.main_color.red, this.main_color.green, this.main_color.blue, this.main_color.alpha);
            ctx.set_line_width(0.5);
            ctx.set_dash(null, 0.0);
        }

        protected void render_background(Context ctx, Config config) {
            if (gradient != null) {
                var boundaries = config.boundaries();
                ctx.rectangle(boundaries.x.min, boundaries.y.min, boundaries.width, boundaries.height);
                GradientLine line = {
                    from : {config.width/2, 0},
                    to: { config.width/2, config.height}
                };
                new LinearGradientDrawer().draw(ctx, config, gradient, line);
                ctx.fill(); 
            }
        }

        protected void render_abscissa(Context ctx, Config config) {
            if (config.x_axis.visible && config.x_axis.axis.visible) {
                config.x_axis.axis.configure(ctx);
                ctx.move_to(config.padding.left + 0.5, config.height - config.padding.bottom + 0.5);
                ctx.line_to(config.width - config.padding.right + 0.5, config.height - config.padding.bottom + 0.5);
                ctx.stroke();
                restore(ctx);
            }
        }
        
        protected void render_ordinate(Context ctx, Config config) {
            if (config.y_axis.visible && config.y_axis.axis.visible) {       
                config.y_axis.axis.configure(ctx);     
                ctx.move_to(config.padding.left + 0.5, config.height - config.padding.bottom + 0.5);
                ctx.line_to(config.padding.left + 0.5, config.padding.top + 0.5);
                ctx.stroke();
                restore(ctx);
            }
        }

        protected void render_grid(Context ctx, Config config) {
            this.render_hgrid(ctx, config);
            this.render_vgrid(ctx, config);
        }

        protected void render_vgrid(Context ctx, Config config) {
            var time = new DateTime.now().to_unix();
            for (double i = config.width - config.padding.right; i > config.padding.left; i -= config.x_axis.tick_length) {
                if (config.x_axis.lines.visible) {
                    config.x_axis.lines.configure(ctx);
                    ctx.move_to((int) i + 0.5, 0.5 + config.height - config.padding.bottom);
                    ctx.line_to((int) i + 0.5, 0.5 + config.padding.top);
                    ctx.stroke();
                    restore(ctx);
                }
                
                // Labels
                if (config.x_axis.visible && config.x_axis.labels.visible) {
                    config.x_axis.labels.font.configure(ctx);
                    var text = new DateTime.from_unix_local(time).format("%H:%M:%S");
                    TextExtents extents;
                    ctx.text_extents(text, out extents);
                    
                    ctx.move_to(i + 0.5 - extents.width / 2, 0.5 + config.height - config.padding.bottom + config.x_axis.labels.extents.height + Grid.ABSCISSA_TIME_PADDING);
                    ctx.show_text(text);
                    ctx.stroke();
                }
                time -= (int) config.x_axis.tick_interval;
            }
        }

        protected void render_hgrid(Context ctx, Config config) {
            
            var boundaries = config.boundaries();
            foreach(float position in config.y_axis.ticks.values) {

                var y = boundaries.height + boundaries.y.min - position * config.y_axis.get_ratio();
                if(y < boundaries.y.min) {
                    break;
                }
                if (config.y_axis.lines.visible) {
                    config.y_axis.lines.configure(ctx);
                    ctx.move_to(0.5 + boundaries.x.max, (int) y + 0.5);
                    ctx.line_to(boundaries.x.min + 0.5, (int) y  + 0.5);
                    ctx.stroke();
                    restore(ctx);
                }

                //Labels
                if (config.y_axis.visible && config.y_axis.labels.visible) {
                    config.y_axis.labels.font.configure(ctx);
                    var value = format_for_y_axis(config.y_axis.unit, position);
    
                    TextExtents extents;
                    ctx.text_extents(value, out extents);
                    ctx.move_to(boundaries.x.min - extents.width - 5, y + (extents.height / 2) + 0.5);
                    ctx.show_text(value);
                    ctx.stroke();
                }
            }
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
    }
}