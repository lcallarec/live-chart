using Cairo;

namespace LiveChart {

    public abstract class Grid : Drawable, Object {

        public string unit {
            get; set construct;
        }
        
        public void draw(Bounds bounds, Context ctx, Geometry geometry) {
            this.render_abscissa(ctx, geometry);
            this.render_ordinate(ctx, geometry);            
            this.render_grid(bounds, ctx, geometry);
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
                
                ctx.move_to(i + 0.5 - extents.width / 2, 0.5 + geometry.height - geometry.padding.bottom + 11);
                ctx.show_text(text);
                time -= 60 / (int) geometry.x_ratio;
            }
            ctx.stroke();
            ctx.set_dash(null, 0.0);           
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
        public FixedDistanceGrid(string unit = "",int distance = 20) {
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