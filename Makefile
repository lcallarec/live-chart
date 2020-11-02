
.PHONY: docs

docs:
	rm -rf docs
	valadoc src/area.vala src/axis.vala src/background.vala src/bar.vala src/bounds.vala src/chart.vala \
	src/config.vala src/drawable_serie.vala src/drawable.vala src/font.vala src/grid.vala \
	src/labels.vala src/legend.vala src/line_area.vala src/line.vala src/path.vala \
	src/points.vala src/serie.vala src/series.vala src/smooth_line_area.vala src/smooth_line.vala \
	src/utils.vala src/values.vala \
	-o Livechart --pkg=gtk+-3.0 --pkg=gee-0.8
	mv Livechart docs
	




