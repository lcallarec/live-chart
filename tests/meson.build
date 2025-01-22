
test_sources = files(
    'area.vala',
    'axis.vala',
    'background.vala',
    'bar.vala',
    'bounds.vala',
    'chart.vala',
    'config.vala',
    'geometry.vala',
    'grid.vala',
    'fakes.vala',
    'legend.vala',
    'line_area.vala',
    'line.vala',
    'max_bound_line.vala',
    'min_bound_line.vala',    
    'points.vala',
    'region/curve_resolver.vala',
    'region/bezier_intersector.vala',
    'region/segment_intersector.vala',
    'runner.vala',
    'serie.vala',
    'series.vala',
    'smooth_line_area.vala',
    'smooth_line.vala',
    'threshold_line.vala',
    'utils.vala',
    'values.vala',
)

vala_args += ['--enable-deprecated']
test('livechart-test', executable('livechart-test', test_sources, vala_args: vala_args, dependencies: deps + [livechart_dep], build_by_default: false))

