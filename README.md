# quickMSBuild
This is a collection of modification files aimed at enhancing Visual Studio C++ projects, in order to produce easier and more consistent builds.

Build Status:
[![Build status](https://ci.appveyor.com/api/projects/status/s2a3dsli0hbbtmt9/branch/master?svg=true)](https://ci.appveyor.com/project/tmiguelf/quickmsbuild/branch/master)

#### Why quickMSBuild?
If you are experienced Windows developer working with Visual Studio, you may be familiar with the scaling problems as solutions start to incorporate more and more projects. Increasing complicated dependency relationships, incompatible build configurations, libraries from who knows where they come from.\
Professional application may get so complicated to untangle that touching a single piece of the build will cause the whole house of cards (a top which your entire software empire is built upon) come crumbling down.\
This generally leads companies to either seek out other tools to remedy the madness (like CMake), or fall pray into legacy pit fall and become obsolete.

But it need not be that way. MSBuild is much more powerful than most would be led to believe, and it would be much more efficient …had it just been used properly.

quickMSBuild is not by itself a tool, or even a solution. It is instead a working philosophy to help setup clean and reliable builds that can scale well, using MSBuild.

#### Pros:
 * Reduces the size and complexity of vcxproj files
 * Set's up a more modern and more optimized code generation options by default
 * Helps ensure that project configurations across multiple projects (in a complex build system) are consistent
 * Allows for cross platform projects (Windows and Linux) to be created from the same project file (facilitating switching between them from the IDE)

#### Cons:
 * New projects using the default Visual Studio template will not be able to take benefit from this (fortunately new project templates are provided using this system)
 * Creating a new solution from a project template requires you to learn some new extra steps. I.E. Add an additional locations.props file in the same directory as your solution to help you project locate it's dependencies (still easier than to do it the Microsoft way, I will try to improve on this in the future)
 * You will not be able to add extra configurations through the Visual Studio IDE. You will have to add new configurations manually through a text editor (realistically how many times do you need to do this?)
 * Visual studio sometimes has some minor trouble. Not serious tough. Ex. When you create a new project, it may list you project in solution explorer as a Linux project while a Windows configuration is selected. But you can fix this by either saving and reloading Visual Studio, or better yet change the selected configuration (and then change it back) and everything works as normal.
 * Microsoft may roll out an update that may break this :( (not likely)

## Usage
### Quick start
If you just want a quick start this is what you do to start using it:
 1. Install the project templates into your visual studio
 2. Create a new project using the new templates
 3. Save your solution and close Visual Studio (important for the first time you create a solution)
 4. Create a "locations.props" file in the same directory as your solution. Please see section "locations.props" bellow.
 5. **Optional**. Create a repoLocations.props to indicate where other projects live.

### Detail
This setup works on the principle of exploiting arcane knowledge of [MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild?view=vs-2019), all of which is publicly document in books like [Inside the Microsoft Build Engine](https://www.microsoftpressstore.com/store/inside-the-microsoft-build-engine-using-msbuild-and-9780735645240).
A .vcxproj file is essentially an XML with structured information with instructions on how to setup the build. And we will take advantage of the [Import]( https://docs.microsoft.com/en-us/visualstudio/msbuild/import-element-msbuild?view=vs-2019) statement to load into the project other configurations that are defined in an external file.


TODO


### locations.props
The purpose of this file is to paired with a .sln file and serve as a well-known location that the projects can easily find, where information regarding all other locations in your version control repository can be found.
This file, other than the standard XML header elements, it need only 2 blocks:
 1 . A [PropertyGroup]( https://docs.microsoft.com/en-us/visualstudio/msbuild/propertygroup-element-msbuild?view=vs-2019) element creating the following properties:
  * DebugDataPath - Indicating the location where the .pdb and .map of will be output (by default). If you are a professional software company with clients, you would want to save these.
  * RuntimePath - Where the binary outputs will go (by default). Where you would setup your test environment to run your binaries on.
2. An [ImportGroup]( https://docs.microsoft.com/en-us/visualstudio/msbuild/importgroup-element?view=vs-2019) element, where it will have additional [Import]( https://docs.microsoft.com/en-us/visualstudio/msbuild/import-element-msbuild?view=vs-2019) to import “repoLocation.props” files from either the current repository or other repositories imported as a git submodule.
Example:
```xml
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
	<PropertyGroup Label="locations">
		<!-- Outputs -->
		<DebugDataPath>$([MSBUILD]::NormalizeDirectory($(MSBuildThisFileDirectory)DebugData/))</DebugDataPath>
		  <RuntimePath>$([MSBUILD]::NormalizeDirectory($(MSBuildThisFileDirectory)Runtime/))</RuntimePath>
	</PropertyGroup>

	<ImportGroup Label="PropertySheets">
		<Import Project="$(MSBuildThisFileDirectory) repoLocations.props" />
<!-- Other git submodules locations-->
	</ImportGroup>
</Project>
```

### repoLocations.props
The purpose of this file is to pass information about the location of projects available in your source control repository (especially important in a multi repository system). You can place this file at the top level of your repository, but it not need be, this file can be placed anywhere else. It should be the responsibility of the external repository that imports the current repository to provide a “locations.props” file to their projects and encode the right location of the “repoLocations.props”. (Note that the file may not even be named repoLocations.props)
This file, other than the standard XML header elements, it need only 1 block, the [PropertyGroup]( https://docs.microsoft.com/en-us/visualstudio/msbuild/propertygroup-element-msbuild?view=vs-2019) element, listing sub-elements that encode the locations of other projects in this repository (that you intend to be accessible externally).
Ex.
```xml
<?xml version="1.0" encoding="utf-8"?>
<Project ToolsVersion="15.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
	<PropertyGroup Label="locations">
		<quickMSBuildPath>$(MSBuildThisFileDirectory)quickMSBuild\</quickMSBuildPath>
		<!-- Other project paths -->
	</PropertyGroup>
</Project>
```

## Requirements
Visual studio 2019 version 16.6 or higher
MSBuild with build tools version 16.6 or higher

Although technically you only need the tools you intend to use, it is recommend that you have at least the MSVC toolset and the "Linux development with C++" toolset to take advantage of this.
If you want to use it with clang you can do that too, it should work, but I haven't put in much time to support clang.

## Building the templates
You will require the "Visual Studio extension development" toolset installed to be able to compile it. Once that is done you should be able to build the solution in "quickTemplates", and then run the generated binary to install the new project templates into your Visual Studio.

## Future plans
Update the clang compiler configurations to have a build setup in the same spirit of what's already in place for MSVC and g++

On a far future ahead. I intend to extend the toolset to be able to compile using g++ and MSBuild on Linux natively (i.e. without using ssh or WSL). Although this is technically feasible with the existing tool sets, the scripts to do so haven't been written yet.
