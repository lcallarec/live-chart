project('live-chart', ['vala', 'c'])

cc = meson.get_compiler('c')
libm = cc.find_library('m', required: true)

gtk = dependency('gtk+-3.0', version: '>= 3.22')
gee = dependency('gee-0.8')

vala_args = ['--target-glib=2.50']

deps = [
  gtk,
  gee,
  libm
]

subdir('src')
subdir('tests')
subdir('examples')
