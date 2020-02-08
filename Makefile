.PHONY: run example

run: example
	./example

example:
	valac --pkg gtk+-3.0 --pkg gee-0.8 -X -lm \
	examples/live-chart.vala src/drawable.vala src/chart.vala src/grid.vala src/points.vala src/background.vala src/geometry.vala src/point.vala \
	src/bar.vala src/line.vala src/values.vala src/value.vala \
	-o example

