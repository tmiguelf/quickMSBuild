//======== ======== ======== ======== ======== ======== ======== ========
///	\file
///		Export definition for dynamicLib
///
///	\copyright
///		
//======== ======== ======== ======== ======== ======== ======== ========

#pragma once

#include <extension/dll_api_macros.h>

#ifdef _dynamicLib_EXPORTS_
#	define dynamicLib_API DLL_EXPORT
#else
#	define dynamicLib_API DLL_IMPORT
#endif // _dynamicLib_EXPORTS_
