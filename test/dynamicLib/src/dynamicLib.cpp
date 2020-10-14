//======== ======== ======== ======== ======== ======== ======== ========
///	\file
///
///	\copyright
///		
//======== ======== ======== ======== ======== ======== ======== ========

#include "dynamicLib/dynamicLib.hpp"

#include <staticLib/staticLib.hpp>

dynamicLib_API uint32_t funcDynamic()
{
	return 5 * funcStatic();
}

