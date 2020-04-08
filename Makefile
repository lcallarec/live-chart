
.PHONY: docs

docs:
	rm -rf docs
	valadoc src/chart.vala src/config.vala src/grid.vala src/legend.vala src/axis.vala src/bounds.vala src/drawable.vala \
	src/values.vala src/drawable_serie.vala src/serie.vala src/path.vala \
	src/points.vala src/utils.vala src/line.vala src/background.vala \
	-o Livechart --pkg=gtk+-3.0 --pkg=gee-0.8
	mv Livechart docs
	




