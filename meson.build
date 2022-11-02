project('live-chart', ['vala', 'c'], version: '1.9.1')

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
subdir('tests')
subdir('examples')
