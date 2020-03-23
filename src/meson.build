
sources = files(
    'area.vala',
    'axis.vala',
    'background.vala',
    'bar.vala',
    'bounds.vala',
    'chart.vala',
    'config.vala',
    'drawable_serie.vala',
    'drawable.vala',
    'grid.vala',
    'legend.vala',
    'line_area.vala',
    'line.vala',
    'point.vala',
    'points.vala',
    'serie.vala',
    'smooth_line_area.vala',
    'smooth_line.vala',
    'value.vala',
    'values.vala'
)

livechart_static_lib = static_library('livechart', [sources], dependencies: deps, vala_args: vala_args)
livechart_dep = declare_dependency(include_directories: include_directories('.'), link_with: livechart_static_lib)
