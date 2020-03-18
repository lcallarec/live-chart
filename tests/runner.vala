void main (string[] args) {

    Test.init(ref args);

    register_geometry();
    register_bounds();

    Test.run();
}