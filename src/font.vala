using Cairo;

namespace LiveChart { 

    public class Font {
        public uint8 size { get; set; }
        public string face { get; set; }
        public FontSlant slant { get; set; }
        public FontWeight weight { get; set; }
        public Gdk.RGBA color { get; set; }

        public Font() {
            size = 10;
            face = "Sans serif";
            slant = FontSlant.NORMAL;
            weight = FontWeight.NORMAL;
            color = {0.4f, 0.4f, 0.4f, 1.0f};
        }

        public void configure(Context ctx) {
            ctx.select_font_face(face, slant, weight);
            ctx.set_font_size(size);
            ctx.set_source_rgba(color.red, color.green, color.blue, color.alpha);
        }
    }
}
