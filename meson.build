project('live-chart', ['vala', 'c'], version: '1.9.1-RO')

cc = meson.get_compiler('c')
libm = cc.find_library('m', required: true)

#setting up GEE
gee = dependency('gee-0.8')
vala_args = ['--target-glib=2.50']

#setting up gtk
gtk_major = 3

if gtk_major == 3
  gtk = dependency('gtk+-3.0', version: '>= 3.22')
  vala_args += ['--define=GTK3']
endif

if gtk_major == 4
  gtk = dependency('gtk4')
  vala_args += ['--define=GTK4']
endif

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
