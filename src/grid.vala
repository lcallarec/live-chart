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

        public void draw(Bounds bounds, Context ctx, Geometry geometry) {
            this.render_abscissa(ctx, geometry);
            this.render_ordinate(ctx, geometry);            
            this.render_grid(bounds, ctx, geometry);
            this.update_bounding_box(geometry);
            this.debug(ctx);
        }

        public BoundingBox get_bounding_box() {
            return this.bounding_box;
        }

        protected virtual void render_abscissa(Context ctx, Geometry geometry) {
            ctx.set_source_rgba(0.5, 0.5, 0.5, 1.0);
            ctx.set_line_width(0.5);
            
            ctx.move_to(geometry.padding.left + 0.5, geometry.height - geometry.padding.bottom + 0.5);
            ctx.line_to(geometry.width - geometry.padding.right + 0.5, geometry.height - geometry.padding.bottom + 0.5);
            ctx.stroke();       
        }

        protected virtual void render_ordinate(Context ctx, Geometry geometry) {
            ctx.set_source_rgba(0.5, 0.5, 0.5, 1.0);
            ctx.set_line_width(0.5);

            ctx.move_to(geometry.padding.left + 0.5, geometry.height - geometry.padding.bottom + 0.5);
            ctx.line_to(geometry.padding.left + 0.5, geometry.padding.top + 0.5);
            ctx.stroke();
        }

        protected virtual void render_grid(Bounds bounds, Context ctx, Geometry geometry) {
            ctx.set_source_rgba(0.4, 0.4, 0.4, 1.0);

            this.render_hgrid(bounds, ctx, geometry);
            this.render_vgrid(ctx, geometry);
        }

        protected virtual void render_vgrid(Context ctx, Geometry geometry) {
            var time = new DateTime.now().to_unix();
            ctx.set_dash({5.0}, 0);
            
            for (double i = geometry.width - geometry.padding.right; i > geometry.padding.left; i -= 60) {
                ctx.move_to(i + 0.5, 0.5 + geometry.height - geometry.padding.bottom);
                ctx.line_to(i + 0.5, 0.5 + geometry.padding.top);
                
                // Values
                var text = new DateTime.from_unix_local(time).format("%H:%M:%S");
                TextExtents extents;
                ctx.text_extents(text, out extents);
                
                ctx.move_to(i + 0.5 - extents.width / 2, 0.5 + geometry.height - geometry.padding.bottom + Grid.ABSCISSA_TIME_PADDING);
                ctx.show_text(text);
                time -= 60 / (int) geometry.x_ratio;
            }
            ctx.stroke();
            ctx.set_dash(null, 0.0);           
        }

        protected void update_bounding_box(Geometry geometry) {
            var boundaries = geometry.boundaries();
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
        protected abstract void render_hgrid(Bounds bounds, Context ctx, Geometry geometry);
    }

    public class FixedValueGrid : Grid {

        private int steps;
        public FixedValueGrid(string unit = "",int steps = 20) {
            this.unit = unit;
            this.steps = steps;
        }
   
        protected override void render_hgrid(Bounds bounds, Context ctx, Geometry geometry) {
            var y_scaled_pos = 0.0;
            for (double i = geometry.height - geometry.padding.bottom; i > geometry.padding.top; i -= steps * geometry.y_ratio) {

                if (i < geometry.padding.top) {
                    break;
                }
                ctx.set_dash({5.0}, 0);
                ctx.move_to(0.5 + geometry.width - geometry.padding.right, i + 0.5);
                ctx.line_to(geometry.padding.left + 0.5, i + 0.5);

                //Values
                var s = @"$y_scaled_pos" + unit;
                TextExtents extents;
                ctx.text_extents(s, out extents);
                ctx.move_to(geometry.padding.left - extents.width - 5, i + 0.5);
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
   
        protected override void render_hgrid(Bounds bounds, Context ctx, Geometry geometry) {
            var y_scaled_pos = 0.0;
            for (double i = geometry.height - geometry.padding.bottom; i > geometry.padding.top; i -= this.distance) {

                if (i < geometry.padding.top) {
                    break;
                }
                ctx.set_dash({5.0}, 0);
                ctx.move_to(0.5 + geometry.width - geometry.padding.right, i + 0.5);
                ctx.line_to(geometry.padding.left + 0.5, i + 0.5);

                //Values
                var s = @"$y_scaled_pos" + unit;
                TextExtents extents;
                ctx.text_extents(s, out extents);
                ctx.move_to(geometry.padding.left - extents.width - 5, i + 0.5);
                ctx.show_text(s);
                y_scaled_pos += (geometry.height / (int) bounds.upper) * this.distance;
            }
            ctx.stroke();            
        }
    }
}