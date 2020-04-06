const int SURFACE_WIDTH = 10;
const int SURFACE_HEIGHT = 10;

void cairo_background(Cairo.Context context, int? width = null, int? height = null) {
    context.set_source_rgba(0.0, 0.0, 0.0, 1.0);
    context.rectangle(0, 0, width != null ? width : SURFACE_WIDTH, height != null ? height : SURFACE_HEIGHT);
    context.fill();
}

LiveChart.Config create_config(int? width = null, int? height = null) {
    var config = new LiveChart.Config();
    config.width = width != null ? width : SURFACE_WIDTH;
    config.height = height != null ? height : SURFACE_HEIGHT;
    config.padding = { 0, 0, 0, 0};

    return config;
}