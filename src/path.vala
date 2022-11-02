using Cairo;

namespace LiveChart {
    // see https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-set-dash
    public struct Dash {
        double[]? dashes;
        double offset;
        public Dash() {
            offset = 0;
        }
    }

    public class Path : Object {
        public double width {get; set; }
        public Dash? dash;
        public Gdk.RGBA color { get; set; }
        public bool visible {get; set; }

        public Path(double width = 0.5, Gdk.RGBA color = { 1.0f, 1.0f, 1.0f, 1.0f }, bool visible = true, Dash? dash = null) {
            this.width = width;
            this.color = color;
            this.visible = true;
            this.dash = dash;
        }

        public void configure(Context ctx) {
            if (visible) {
                if (dash != null) {
                    ctx.set_dash(dash.dashes, dash.offset);
                }
                ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
                ctx.set_line_width(width);
            }
        }
    }  
}