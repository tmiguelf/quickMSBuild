//======== ======== ======== ======== ======== ======== ======== ========
///	\file
///		Provides utilities to link dynamic libraries/binaries (.dll .so)
///
///	\author Tiago Freire
//======== ======== ======== ======== ======== ======== ======== ========

#pragma once

#ifdef _WIN32
#	define DLL_IMPORT		__declspec(dllimport)
#	define DLL_EXPORT		__declspec(dllexport)
#	define DLL_LOCAL
#else
#	if __GNUC__ >= 4
#		define DLL_IMPORT	__attribute__ ((visibility ("default")))
#		define DLL_EXPORT	__attribute__ ((visibility ("default")))
#		define DLL_LOCAL	__attribute__ ((visibility ("hidden")))
#	else
#		define DLL_IMPORT
#		define DLL_EXPORT
#		define DLL_LOCAL
#	endif
#endif
