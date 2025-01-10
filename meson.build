project('live-chart', ['vala', 'c'], version: '1.10.0')

cc = meson.get_compiler('c')
libm = cc.find_library('m', required: true)

gtk = dependency('gtk4', version: '>= 4.0')
gee = dependency('gee-0.8')

vala_args = ['--target-glib=2.50']

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

if get_option('tests')
  subdir('tests')
endif

if get_option('examples')
  subdir('examples')
endif

if get_option('docs')
  outdir = 'docs'

  custom_target(
    'valadoc',
    command: [
      find_program('valadoc'),
      sources,
      '--package-name=Livechart',
      '--package-version=' + meson.project_version(),
      '--verbose',
      '--force',
      '--pkg=gtk4',
      '--pkg=gee-0.8',
      '--target-glib=2.50',
      '-o', meson.project_source_root() / outdir
    ],
    build_by_default: true,
    output: outdir,
    depends: livechart_lib
  )
endif
