using Cairo;

namespace LiveChart {

    public class Grid : Object {

        public string unit { get; set construct ; default = ""; }
        private int steps;

        public Grid(string unit = "",int steps = 80) {
            this.unit = unit;
            this.steps = steps;
        }

        public void draw(Bounds bounds, Context ctx, Geometry geometry) {
            this.render_abscissa(ctx, geometry);
            this.render_ordinate(ctx, geometry);            
            this.render_grid(bounds, ctx, geometry);
        }

        private void render_abscissa(Context ctx, Geometry geometry) {
            ctx.set_source_rgba(0.5, 0.5, 0.5, 1.0);
            ctx.set_line_width(0.5);
            
            ctx.move_to(geometry.padding.left + 0.5, geometry.height - geometry.padding.bottom + 0.5);
            ctx.line_to(geometry.width - geometry.padding.right + 0.5, geometry.height - geometry.padding.bottom + 0.5);
            ctx.stroke();            
        }

        private void render_ordinate(Context ctx, Geometry geometry) {
            ctx.set_source_rgba(0.5, 0.5, 0.5, 1.0);
            ctx.set_line_width(0.5);

            ctx.move_to(geometry.padding.left + 0.5, geometry.height - geometry.padding.bottom + 0.5);
            ctx.line_to(geometry.padding.left + 0.5, geometry.padding.top + 0.5);
            ctx.stroke();
        }

        private void render_grid(Bounds bounds, Context ctx, Geometry geometry) {
            ctx.set_source_rgba(0.4, 0.4, 0.4, 1.0);

            this.render_hgrid(bounds, ctx, geometry);
            this.render_vgrid(ctx, geometry);
        }

        private void render_hgrid(Bounds bounds, Context ctx, Geometry geometry) {
            var y_scaled_pos = 0.0;
            for (double i = geometry.height - geometry.padding.bottom; i > geometry.padding.top; i -= this.steps) {

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
                y_scaled_pos += (int) bounds.upper / (geometry.height / this.steps);
            }
            ctx.stroke();            
        }

        //  private void render_hgrid(Bounds bounds, Context ctx, Geometry geometry) {
        //      var y_scaled_pos = 0.0;
        //      stdout.printf("height : %d\n", geometry.height);
        //      var steps = this.steps
        //      for (double i = geometry.height - geometry.padding.bottom; i > geometry.padding.top; i -= (geometry.height / this.steps)) {

        //          if (i < geometry.padding.top) {
        //              break;
        //          }
        //          ctx.set_dash({5.0}, 0);
        //          ctx.move_to(0.5 + geometry.width - geometry.padding.right, i + 0.5);
        //          ctx.line_to(geometry.padding.left + 0.5, i + 0.5);

        //          //Values
        //          var s = @"$y_scaled_pos" + unit;
        //          TextExtents extents;
        //          ctx.text_extents(s, out extents);
        //          ctx.move_to(geometry.padding.left - extents.width - 5, i + 0.5);
        //          ctx.show_text(s);
        //          y_scaled_pos += (int) bounds.upper / this.steps;
        //      }
        //      ctx.stroke();            
        //  }

        private void render_vgrid(Context ctx, Geometry geometry) {
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
    }
}