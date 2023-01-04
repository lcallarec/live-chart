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
                red = 0.4f,
                green = 0.4f,
                blue = 0.4f,
                alpha = 1.0f
            };
        }

        public void draw(Context ctx, Config config) {
            if (visible) {
                this.render_abscissa(ctx, config);
                this.render_ordinate(ctx, config);            
                this.render_grid(ctx, config);
                this.update_bounding_box(config);
                this.debug(ctx);
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
            
            var grid_interval = (int64)(config.x_axis.tick_interval * config.time.conv_sec);
            var time = config.time.current;
            var gap = 0.0;
            if(config.x_axis.slide_timeline && grid_interval != 0){
                time = time - (config.time.current % grid_interval);
                gap = (config.time.current - time) * config.x_axis.get_ratio() / config.time.conv_sec;
            }
            
            for (double i = config.width - config.padding.right - gap; i > config.padding.left; i -= config.x_axis.tick_length) {
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
                    var text = config.time.get_time_str(time, config.x_axis.show_fraction);
                    TextExtents extents;
                    ctx.text_extents(text, out extents);
                    
                    ctx.move_to(i + 0.5 - extents.width / 2, 0.5 + config.height - config.padding.bottom + config.x_axis.labels.extents.height + Grid.ABSCISSA_TIME_PADDING);
                    ctx.show_text(text);
                    ctx.stroke();
                }
                time -= grid_interval;
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

        protected void debug(Context ctx) {
            var debug = Environment.get_variable("LIVE_CHART_DEBUG");
            if(debug != null) {
                ctx.rectangle(bounding_box.x, bounding_box.y, bounding_box.width, bounding_box.height);
                ctx.stroke();
            }
        }    
    }
}