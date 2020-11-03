
sources = files(
    'area.vala',
    'axis.vala',
    'background.vala',
    'bar.vala',
    'bounds.vala',
    'chart.vala',
    'config.vala',
    'drawable.vala',
    'font.vala',
    'grid.vala',
    'labels.vala',
    'legend.vala',
    'line_area.vala',
    'line.vala',
    'path.vala',
    'points.vala',
    'serie.vala',
    'serie_renderer.vala',
    'series.vala',
    'smooth_line_area.vala',
    'smooth_line.vala',
    'utils.vala',
    'values.vala'
)

livechart_static_lib = static_library('livechart_static', [sources], dependencies: deps, vala_args: vala_args)
livechart_static_dep = declare_dependency(include_directories: include_directories('.'), link_with: livechart_static_lib)

livechart_lib = library(
    'livechart',
    [sources],
    dependencies: deps,
    vala_args: vala_args,
    install: true,
    install_dir: [true, true, true]
)

pkg = import('pkgconfig')
pkg.generate(
    version: meson.project_version(),
    libraries: livechart_lib,
    description: 'Live-chart headers',
    name: 'livechart',
    filebase: 'livechart'
)

livechart_dep = declare_dependency(
    link_with: livechart_lib,
    dependencies: deps,
    include_directories: [include_directories('.')]
)
