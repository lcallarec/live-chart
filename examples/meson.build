examples = [
  # [target name, [sources...]]
  ['example', ['live-chart.vala']],
  ['example-fixed-max', ['fixed-max.vala']],
  ['example-hide-parts', ['hide-parts.vala']],
  ['example-configure-labels', ['configure-labels.vala']],
  ['example-remove-serie', ['remove-serie.vala']],
  ['example-replace-chart', ['replace-chart.vala']],
  ['example-static-renderer', ['static-renderer.vala']],
  ['example-static-chart', ['static-chart.vala']],
  ['example-usec', ['live-chart-usec.vala']],
]

foreach example : examples
  executable(example[0],
    example[1],
    dependencies: deps + [livechart_dep],
    build_by_default: false
  )
endforeach
