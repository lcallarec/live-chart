using Cairo;

namespace LiveChart {
    
     public abstract class Legend : Drawable, Object {

        public bool visible { get; set; default = true; }
        public Labels labels = new Labels();
        public LegendSymbol symbol = LegendSymbol();

        protected Gee.ArrayList<Seriable> series = new Gee.ArrayList<Seriable>();
        protected BoundingBox bounding_box = BoundingBox() {
            x=0, 
            y=0, 
            width=0,
            height=0
        };
        public abstract double get_needed_height();
            
        public void add_legend(Seriable serie) {
            series.add(serie);
        }

        public abstract void draw(Context ctx, Config config);
        public BoundingBox get_bounding_box() {
            return bounding_box;
        }
    }

    public struct LegendSymbol {
        public double width;
        public double height;
        public double radius;
        public LegendSymbol() {
            width = 15;
            height = 10;
            radius = 0;
        }
    }

    public class HorizontalLegend : Legend {

        private double needed_height = 10;
        private LegendSymbolDrawer symbol_drawer = new LegendSymbolDrawer();
        public override double get_needed_height() {
            return needed_height;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                
                var boundaries = config.boundaries();
                
                labels.font.configure(ctx);
                TextExtents size = name_extents("A", ctx);
                needed_height = double.max(size.height, symbol.height) * 2;
                
                var x_labels_height = config.x_axis.get_labels_needed_size().height;
                var base_y = boundaries.y.max + x_labels_height;
                var pos = 0.0;
                series.foreach((serie) => {
                    labels.font.configure(ctx);
                    TextExtents extents = name_extents(serie.name, ctx);
                    ctx.move_to(
                        boundaries.x.min + pos + symbol.width + 2,
                        base_y + (needed_height - size.height) / 2 + size.height
                    );
                    ctx.show_text(serie.name);

                    symbol_drawer.draw(ctx, {boundaries.x.min + pos, base_y + (needed_height - symbol.height) / 2}, symbol, serie.line.color);

                    pos += symbol.width + extents.width + 20;

                    return true;
                });
                
                this.update_bounding_box(config, pos);
                this.debug(ctx);
            }
        }
   
        private TextExtents name_extents(string name, Context ctx) {
            TextExtents name_extents;
            ctx.text_extents(name, out name_extents);

            return name_extents;
        }

        private void update_bounding_box(Config config, double width) {
            var boundaries = config.boundaries();
            this.bounding_box = BoundingBox() {
                x=boundaries.x.min,
                y=boundaries.y.max ,
                width=width,
                height=20
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

    public class NoopLegend : Legend {
        public override void draw(Context ctx, Config config) {}
        public override double get_needed_height() {return 0;}
    }

    public class LegendSymbolDrawer {
        public void draw(Context ctx, Coordinate at, LegendSymbol symbol, Gdk.RGBA color) {

            ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
            if (symbol.radius > 0) {
                Coordinate p1 = {at.x, at.y + symbol.radius};
                ctx.move_to(p1.x, p1.y);
                //top-left corner
                ctx.curve_to(p1.x, p1.y, at.x, at.y, at.x + symbol.radius, at.y);
                //top line      
                Coordinate p2 = {at.x + symbol.width - symbol.radius, at.y};
                ctx.line_to(p2.x, p2.y);
                //top-right corner
                ctx.curve_to(p2.x, p2.y, at.x + symbol.width, at.y, at.x + symbol.width, at.y + symbol.radius);
                //right line
                Coordinate p3 = {at.x + symbol.width, at.y + symbol.height - symbol.radius};
                ctx.line_to(p3.x, p3.y);
                //bottom-right corner                
                ctx.curve_to(p3.x, p3.y, at.x + symbol.width, at.y + symbol.height, at.x + symbol.width - symbol.radius, at.y + symbol.height);
                //bottom line
                Coordinate p4 = {at.x + symbol.radius, at.y + symbol.height};
                ctx.line_to(p4.x, p4.y);
                //bottom-left corner
                ctx.curve_to(p4.x, p4.y, at.x, at.y + symbol.height, at.x, at.y + symbol.height - symbol.radius);
                //left line
                ctx.line_to(p1.x, p1.y);
            } else {
                ctx.rectangle(
                    at.x,
                    at.y,
                    symbol.width,
                    symbol.height
                );
            }
            ctx.fill();
        }
    }
}