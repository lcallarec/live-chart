
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
    'font.vala',
    'grid.vala',
    'labels.vala',
    'legend.vala',
    'line_area.vala',
    'line.vala',
    'path.vala',
    'points.vala',
    'serie.vala',
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
    version: '0.1',
    libraries: livechart_lib,
    description: 'Kangaroo headers',
    name: 'livechart',
    filebase: 'livechart'
)

livechart_dep = declare_dependency(
    link_with: livechart_lib,
    dependencies: deps,
    include_directories: [include_directories('.')]
)
