project('Example', ['d', 'c', 'cpp'], default_options: [
		'buildtype=release',				# build debug by default
		'default_library=shared',			# build shared libraries by default
		'layout=flat',					# keep all outputs together by default

		# these are forced options, but meson doesn't let me set these up separately before I call project() (TODO https://github.com/mesonbuild/meson/issues/5179)
		'warning_level=3',				# always max warnings
		'b_pch=false',					# we don't want precompiled headers
		'b_staticpic=true',				# use PIC even for static libraries
		'c_std=c99',					# strict C99
		'c_winlibs=',					# we define our own Windows libraries
		'cpp_std=c++11',				# strict C++11
		'cpp_eh=sc',					# shut the compiler up in some cases
		'cpp_winlibs=',					# likewise as with c_winlibs
	],
	license: 'MIT')


subproject('libui')

libuid_sources = [
	'source/ui/App.d',
	'source/ui/Area.d',
	'source/ui/Box.d',
	'source/ui/Button.d',
	'source/ui/Checkbox.d',
	'source/ui/ColorButton.d',
	'source/ui/Combobox.d',
	'source/ui/Control.d',
	'source/ui/Core.d',
	'source/ui/DateTimePicker.d',
	'source/ui/Draw.d',
	'source/ui/EditableCombobox.d',
	'source/ui/Entry.d',
	'source/ui/FontButton.d',
	'source/ui/Form.d',
	'source/ui/Grid.d',
	'source/ui/Group.d',
	'source/ui/Label.d',
	'source/ui/Menu.d',
	'source/ui/MenuItem.d',
	'source/ui/MultilineEntry.d',
	'source/ui/package.d',
	'source/ui/ProgressBar.d',
	'source/ui/RadioButtons.d',
	'source/ui/Separator.d',
	'source/ui/Slider.d',
	'source/ui/Spinbox.d',
	'source/ui/Tab.d',
	'source/ui/Window.d'
	]

source_root = meson.source_root()
sources_dir = include_directories('source/')

examples_dir = include_directories('examples/')

libuid = static_library('libuid',libuid_sources, include_directories : sources_dir, install : false)
# TODO: add support for Windows and Mac dynamic library

libuid_OS = host_machine.system()

if libui_OS == 'windows'
	libui_args = '-L=' + meson.current_build_dir() + '/meson-out/libui.dll'
elif libui_OS == 'darwin'
	libui_args = '-L=' + meson.current_build_dir() + '/meson-out/libui.dylib
else
	libui_args = '-L=' + meson.current_build_dir() + '/meson-out/libui.so.0'
endif


executable('example1', 'examples/example1.d', link_with : libuid, link_args: [libui_args], include_directories : [examples_dir, sources_dir])
executable('example2', 'examples/example2.d', link_with : libuid, link_args: [libui_args], include_directories : [examples_dir, sources_dir])