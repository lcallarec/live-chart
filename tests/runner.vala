void main (string[] args) {

    Test.init(ref args);
    Gtk.init();

    prepare_screenshots_directory();

    register_config();
    register_bounds();
    register_values();
    register_points();
    register_chart();
    register_axis();
    register_area();
    register_line_area();
    register_line();
    register_smooth_line();
    register_smooth_line_area();
    register_bar();
    register_utils();
    register_grid();
    register_background();
    register_legend();
    register_serie();
    register_series();
    register_threshold_line();
    register_min_bound_line();
    register_max_bound_line();
    register_regions();
    register_intersections();
    
    Test.run();
}

private void prepare_screenshots_directory() {
    try {
        var directory = File.new_for_path("screenshots");
        if(directory.query_exists()) {
            Dir screenshot_dir = Dir.open("screenshots", 0);
            string? name = null;
            while ((name = screenshot_dir.read_name ()) != null) {
                File.new_for_path(@"screenshots/$(name)").delete();
            }
            directory.delete();
        }
        directory.make_directory();
    } catch (Error e) {
        message(@"Error while preparing screenshots directory : $(e.message)");
    }
}