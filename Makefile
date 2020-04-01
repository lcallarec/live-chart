.PHONY: run compile test

run:
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	examples/live-chart.vala src/drawable.vala src/chart.vala src/grid.vala src/points.vala src/background.vala src/config.vala src/point.vala \
	src/bar.vala src/line.vala src/values.vala src/value.vala src/smooth_line.vala src/utils.vala \
	src/bounds.vala src/serie.vala src/drawable_serie.vala src/legend.vala src/axis.vala src/line_area.vala src/smooth_line_area.vala src/area.vala \
	-o example
	./example
	
compile: 
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	examples/live-chart.vala src/drawable.vala src/chart.vala src/grid.vala src/points.vala src/background.vala src/config.vala src/point.vala \
	src/bar.vala src/line.vala src/values.vala src/value.vala src/smooth_line.vala src/axis.vala src/line_area.vala src/smooth_line_area.vala src/area.vala \
	src/bounds.vala src/serie.vala src/drawable_serie.vala src/legend.vala src/utils.vala

test:
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	src/config.vala src/bounds.vala src/drawable.vala src/serie.vala src/drawable_serie.vala src/chart.vala src/background.vala \
	src/line.vala src/legend.vala src/grid.vala src/values.vala src/value.vala src/point.vala src/points.vala src/axis.vala src/area.vala \
	src/line_area.vala src/smooth_line.vala src/smooth_line_area.vala src/bar.vala src/utils.vala \
	tests/runner.vala tests/config.vala tests/bounds.vala tests/values.vala tests/chart.vala tests/points.vala tests/axis.vala \
	tests/cairo.vala tests/line_area.vala tests/line.vala tests/area.vala tests/smooth_line.vala tests/smooth_line_area.vala \
	tests/bar.vala tests/utils.vala tests/grid.vala  \
	-o test
	./test
	
