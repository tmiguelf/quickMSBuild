//======== ======== ======== ======== ======== ======== ======== ========
///	\file
///		Export definition for $projectname$
///
///	\copyright
///		
//======== ======== ======== ======== ======== ======== ======== ========

#pragma once

#include <extension/dll_api_macros.h>

#ifdef _$safeprojectname$_EXPORTS_
#	define $safeprojectname$_API DLL_EXPORT
#else
#	define $safeprojectname$_API DLL_IMPORT
#endif // _$safeprojectname$_EXPORTS_
