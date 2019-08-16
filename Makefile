.PHONY: run example

run: example
	./example

example:
	valac --pkg gtk+-3.0 --pkg gee-0.8 \
	examples/live-chart.vala src/serie_renderer.vala src/bar.vala src/chart.vala src/grid.vala src/serie.vala src/background.vala src/geometry.vala src/point.vala src/line.vala \
	-o example

