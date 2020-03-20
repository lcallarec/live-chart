.PHONY: run compile test

run:
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	examples/live-chart.vala src/drawable.vala src/chart.vala src/grid.vala src/points.vala src/background.vala src/geometry.vala src/point.vala \
	src/bar.vala src/line.vala src/values.vala src/value.vala src/curve.vala \
	src/bounds.vala src/serie.vala src/drawable_serie.vala src/legend.vala \
	-o example
	./example

compile: 
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	examples/live-chart.vala src/drawable.vala src/chart.vala src/grid.vala src/points.vala src/background.vala src/geometry.vala src/point.vala \
	src/bar.vala src/line.vala src/values.vala src/value.vala src/curve.vala \
	src/bounds.vala src/serie.vala src/drawable_serie.vala src/legend.vala

test:
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	src/geometry.vala src/bounds.vala src/drawable.vala src/serie.vala src/drawable_serie.vala src/chart.vala src/background.vala \
	src/line.vala src/legend.vala src/grid.vala src/values.vala src/value.vala src/point.vala src/points.vala \
	tests/runner.vala tests/geometry.vala tests/bounds.vala tests/values.vala tests/chart.vala tests/points.vala \
	-o test
	./test
	
