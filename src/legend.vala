using Cairo;

namespace LiveChart {
    
     public abstract class Legend : Drawable, Object {

        public bool visible { get; set; default = true; }
        public Labels labels = new Labels();

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

    public enum LegendSymbolType {
        QUADRILATERAL,
        CIRCLE
    }

    public class HorizontalLegend : Legend {

        public LegendSymbolType symbol_type { get; set; default = LegendSymbolType.QUADRILATERAL; }
        public uint8 symbol_width { get; set; default = 10; }
        public uint8 symbol_height { get; set; default = 10; }

        private double needed_height = 10;

        public override double get_needed_height() {
            return needed_height;
        }

        public override void draw(Context ctx, Config config) {
            if (visible) {
                
                var boundaries = config.boundaries();
                
                labels.font.configure(ctx);
                TextExtents size = name_extents("A", ctx);
                needed_height = double.max(size.height, symbol_height) * 2;
                
                var x_labels_height = config.x_axis.get_labels_needed_size().height;
                var base_y = boundaries.y.max + x_labels_height;
                var pos = 0;
                series.foreach((serie) => {
                    labels.font.configure(ctx);
                    TextExtents extents = name_extents(serie.name, ctx);
                    ctx.move_to(
                        boundaries.x.min + pos + symbol_width + 2,
                        base_y + (needed_height - size.height) / 2 + size.height
                    );
                    ctx.show_text(serie.name);
             
                    ctx.set_source_rgba(serie.line.color.red, serie.line.color.green, serie.line.color.blue, 1);
                    ctx.rectangle(
                        boundaries.x.min + pos,
                        base_y + (needed_height - symbol_height) / 2,
                        symbol_width,
                        symbol_height
                    );
                    ctx.fill();
                                     
                    pos += symbol_width + (int) extents.width + 20;

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

        private void update_bounding_box(Config config, int width) {
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
}