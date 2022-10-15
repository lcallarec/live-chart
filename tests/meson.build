
test_sources = files(
    'area.vala',
    'axis.vala',
    'background.vala',
    'bar.vala',
    'bounds.vala',
    'chart.vala',
    'config.vala',
    'grid.vala',
    'intersectors.vala',
    'fakes.vala',
    'legend.vala',
    'line_area.vala',
    'line.vala',
    'max_bound_line.vala',
    'min_bound_line.vala',    
    'points.vala',
    'region.vala',
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
test('livechart-test', executable('livechart-test', test_sources, vala_args: vala_args, dependencies: deps + [livechart_dep]))

