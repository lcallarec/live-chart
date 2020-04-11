project('live-chart', ['vala', 'c'], version: '1.3.4')

cc = meson.get_compiler('c')
libm = cc.find_library('m', required: true)

gtk = dependency('gtk+-3.0', version: '>= 3.22')
gee = dependency('gee-0.8')

vala_args = ['--target-glib=2.50']

if get_option('debug') == true
  vala_args += ['--ccode', '--debug']
endif

deps = [
  gtk,
  gee,
  libm
]

subdir('src')
subdir('tests')
subdir('examples')
