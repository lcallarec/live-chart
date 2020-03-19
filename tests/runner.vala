void main (string[] args) {

    Test.init(ref args);
    Gtk.init(ref args);

    register_geometry();
    register_bounds();
    register_values();
    register_chart();
    register_points();

    Test.run();
}