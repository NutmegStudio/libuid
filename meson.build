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


subproject('libui', override_options : ['rfdg=3', 'werror=false'])