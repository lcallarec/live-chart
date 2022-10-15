project('live-chart', ['vala', 'c'], version: '1.9.1')

cc = meson.get_compiler('c')
libm = cc.find_library('m', required: true)

gtk = dependency('gtk+-3.0', version: '>= 3.22')
gee = dependency('gee-0.8')

vala_args = ['--target-glib=2.50', '--enable-experimental']

if meson.version().version_compare('>= 0.47')
  if get_option('debug') == true 
    vala_args += ['--ccode', '--debug']
  endif
endif

deps = [
  gtk,
  gee,
  libm
]

subdir('src')
subdir('tests')
subdir('examples')

if get_option('docs') == true
  valadoc = find_program('valadoc')
  doc_cmd_base = [valadoc,
    '--package-name=livechart',
    '--package-version=' + meson.project_version(),
    '--target-glib=2.50',
    '--force',
    '--pkg=gtk+-3.0',
    '--pkg=glib-2.0',
    '--pkg=gobject-2.0',
    '--pkg=gee-0.8',
    '--directory=@OUTPUT@',
    '@INPUT@'
  ]

  gtkdoc_cmd = [doc_cmd_base,
    '--doclet=gtkdoc',
    '--doclet-arg=' + (meson.current_build_dir() / 'src' / 'livechart.h')
  ]
  custom_target('gtkdoc',
    command: gtkdoc_cmd,
    input: sources,
    output: 'gtkdoc',
    depends: livechart_lib
  )

  custom_target('valadoc',
    command: doc_cmd_base,
    input: sources,
    output: 'valadoc',
    depends: livechart_lib
  )
endif
