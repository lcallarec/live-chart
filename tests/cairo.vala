const int SURFACE_WIDTH = 10;
const int SURFACE_HEIGHT = 10;

void cairo_background(Cairo.Context context) {
    context.set_source_rgba(0.0, 0.0, 0.0, 1.0);
    context.rectangle(0, 0, 10, 10);
    context.fill();
}

LiveChart.Config create_config() {
    var config = new LiveChart.Config();
    config.width = SURFACE_WIDTH;
    config.height = SURFACE_HEIGHT;
    config.padding = { 0, 0, 0, 0};

    return config;
}