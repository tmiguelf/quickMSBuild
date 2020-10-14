//======== ======== ======== ======== ======== ======== ======== ========
///	\file
///		Main entry point
///
///	\copyright
///		
//======== ======== ======== ======== ======== ======== ======== ========

#include <iostream>

#include <dynamicLib/dynamicLib.hpp>
#include <staticLib/staticLib.hpp>

int main(
	[[maybe_unused]] int argc,
	[[maybe_unused]] char* argv[])
{
	std::cout << funcDynamic() << " " << funcStatic() << std::endl;
	return 0;
}
