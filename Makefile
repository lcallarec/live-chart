.PHONY: run compile test

run:
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	examples/live-chart.vala src/drawable.vala src/chart.vala src/grid.vala src/points.vala src/background.vala src/config.vala src/point.vala \
	src/bar.vala src/line.vala src/values.vala src/value.vala src/smooth_line.vala \
	src/bounds.vala src/serie.vala src/drawable_serie.vala src/legend.vala src/axis.vala \
	-o example
	./example

compile: 
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	examples/live-chart.vala src/drawable.vala src/chart.vala src/grid.vala src/points.vala src/background.vala src/config.vala src/point.vala \
	src/bar.vala src/line.vala src/values.vala src/value.vala src/smooth_line.vala src/axis.vala \
	src/bounds.vala src/serie.vala src/drawable_serie.vala src/legend.vala

test:
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	src/config.vala src/bounds.vala src/drawable.vala src/serie.vala src/drawable_serie.vala src/chart.vala src/background.vala \
	src/line.vala src/legend.vala src/grid.vala src/values.vala src/value.vala src/point.vala src/points.vala src/axis.vala \
	tests/runner.vala tests/config.vala tests/bounds.vala tests/values.vala tests/chart.vala tests/points.vala tests/axis.vala \
	-o test
	./test
	
