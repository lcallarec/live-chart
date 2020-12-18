exemple_src = files(
    'demo.vala',
    'basic.vala',
    'other-configuration.vala',
    'fixed-max.vala',
    'hide-parts.vala',
    'experimental-static-chart.vala',
    'bounds-and-thresholds.vala'
)

experimental_example_src = files(
    'experimental/demo.vala',
    'experimental/basic.vala',
    'experimental/other-configuration.vala',
    'experimental/fixed-max.vala',
    'experimental/hide-parts.vala',
    'experimental/experimental-static-chart.vala',
    'experimental/bounds-and-thresholds.vala'
)

executable('demo', exemple_src, vala_args: vala_args, dependencies: deps + [livechart_dep])
executable('experimental-demo', experimental_example_src, vala_args: vala_args, dependencies: deps + [livechart_dep])
