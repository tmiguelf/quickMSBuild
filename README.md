# quickMSBuild
This is a collection of modification files aimed at enhancing Visual Studio C++ projects, in order to produce easier and more consistent builds.

Build Status:
#### CI Suspended until CI tools are updated to the latest copilers


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
This setup works by exploiting some arcane knowledge of [MSBuild](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild?view=vs-2019), all of which is publicly document in books like [Inside the Microsoft Build Engine](https://www.microsoftpressstore.com/store/inside-the-microsoft-build-engine-using-msbuild-and-9780735645240).
A .vcxproj file is essentially an XML with structured information with instructions on how to setup the build. And we will take advantage of the [Import]( https://docs.microsoft.com/en-us/visualstudio/msbuild/import-element-msbuild?view=vs-2019) statement to load into the project other configurations that are defined in an external file.

Let’s take a look at an example of a project file:
```xml
<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
<!-- Project Unique ID
	Each individual project must have a unique ID
	in order for Visual Studio/MSBuild to be able work properly
-->
  <PropertyGroup Label="Globals">
    <ProjectGuid>{0a2614b1-2014-4443-a83b-e8a2bef0f970}</ProjectGuid>
  </PropertyGroup>

<!-- Configuration matrix
	This tells what type of build configurations are available in your project.
	The "Platform" be an indicator of what type of CPU the build is targeting.
	The "Configuration" can be named anything, it doesn't have to be Release
	or Debug, it just usually is that way because that is what normally what
	it is used for. The "Configuration" is just a means for the user to be
	able to setup and choose multiple ways in which the project can be built.
	For the project to work properly the "Configuration" and "Platform" listed
	must be the same as specified in the "Include" attribute of the
	"ProjectConfiguration" node it is in
-->
  <ItemGroup Label="ProjectConfigurations">
    <ProjectConfiguration Include="Debug|x64">
      <Configuration>Debug</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="Release|x64">
      <Configuration>Release</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="WSL_Debug|x64">
      <Configuration>WSL_Debug</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
    <ProjectConfiguration Include="WSL_Release|x64">
      <Configuration>WSL_Release</Configuration>
      <Platform>x64</Platform>
    </ProjectConfiguration>
  </ItemGroup>

<!-- Toolset selection
	This is where we start matching particular configurations
	to the ways in which we want to compile our source code.
	quickMSBuild requires you to define the "CompilerFlavour", "BuildMethod",
	and the "UseDebugLibraries".

	The "CompilerFlavour" is going to define what compiler
	to use. The following are supported:
		- MSVC  - MSVC v143 (Windows only)
		- g++   - gcc/g++ (Linux only)
		- clang - clang compiler (Windows or Linux)

	The "BuildMethod" is going to determine where the build takes place:
		- native - Build on Windows (MSVC or clang compiler)
		- WSL    - Build using Windows Subsytem for Linux (g++ or clang compiler)
		- ssh    - Build remotely on Linux over ssh (g++ or clang compiler)

	The "UseDebugLibraries" option is going to define if
	the build is a Debug build or a Release build

	Everything else, quickMSBuild will deduce for you
	based on the  previous properties
-->
  <PropertyGroup Label="quickMSBuild" Condition="'$(Configuration)'=='Debug'">
    <CompilerFlavour>MSVC</CompilerFlavour>
    <BuildMethod>native</BuildMethod>
    <UseDebugLibraries>true</UseDebugLibraries>
  </PropertyGroup>
  <PropertyGroup Label="quickMSBuild" Condition="'$(Configuration)'=='Release'">
    <CompilerFlavour>MSVC</CompilerFlavour>
    <BuildMethod>native</BuildMethod>
    <UseDebugLibraries>false</UseDebugLibraries>
  </PropertyGroup>
  <PropertyGroup Label="quickMSBuild" Condition="'$(Configuration)'=='WSL_Debug'">
    <CompilerFlavour>g++</CompilerFlavour>
    <BuildMethod>WSL</BuildMethod>
    <UseDebugLibraries>true</UseDebugLibraries>
  </PropertyGroup>
  <PropertyGroup Label="quickMSBuild" Condition="'$(Configuration)'=='WSL_Release'">
    <CompilerFlavour>g++</CompilerFlavour>
    <BuildMethod>WSL</BuildMethod>
    <UseDebugLibraries>false</UseDebugLibraries>
  </PropertyGroup>

<!-- Define the type of output
	The "ConfigurationType" defines the type of generated output:
		- StaticLibrary  - Makes a static library (.lib or .a)
		- DynamicLibrary - Makes a dynamic link library (.dll) or shared object (.so)
		- Application    - Makes an executable
		- Utility        - Makes nothing. Can be used for example to create a header only library
-->
  <PropertyGroup Label="Configuration">
    <ConfigurationType>Application</ConfigurationType>
  </PropertyGroup>

<!-- Where the magic happens
	This is where projects gets most of its properties loaded.

	The first property sheet to be imported MUST be the "locations.props".
	The "locations.props" file can be found by using the macro "$(SolutionDir)"
	and the purpose of it is to load the locations of all visible projects
	that this project might use as a dependency.

	The second property sheet to be imported MUST be the "default.cpp.props"
	from quickMSBuild, which should be easily found without a problem because
	the "locations.props" already loaded for us the macro "$(quickMSBuildPath)"
	with it's location... Neat!
	The purpose of this file is to locate and configure all the build tools.
	This is where most of the magic happens.

	Property files for additional dependencies should go next
-->
  <ImportGroup Label="PropertySheets">
    <Import Project="$(SolutionDir)locations.props" />
    <Import Project="$(quickMSBuildPath)default.cpp.props" />
    <!-- Add your dependencies here-->
    <Import Project="$(staticLibPath)staticLib.import.props" />
    <Import Project="$(dynamicLibPath)dynamicLib.import.props" />
  </ImportGroup>

<!-- Compiler/Linker option configuration
	There shouldn't be much to see here anymore because by default
	the good options are already set by default
-->
  <ItemDefinitionGroup>
    <ClCompile>
      <AdditionalIncludeDirectories>$(ProjectDir)include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
    </ClCompile>
    <Link>
      <SubSystem>Console</SubSystem>
    </Link>
  </ItemDefinitionGroup>

<!-- File list -->
  <ItemGroup>
    <ClCompile Include="src\main.cpp" />
  </ItemGroup>

<!-- Target files
	These files define what happens when you do a "build",
	"compile", or whatever action that needs to take place.
	It also defines what properties are available from
	the visual studio menus.
-->
  <Import Project="$(quickMSBuildPath)default.cpp.targets" />
</Project>
```

### locations.props
The purpose of this file is to paired with a .sln file and serve as a well-known location that the projects can easily find, where information regarding all other locations in your version control repository can be found.
This file, other than the standard XML header elements, it need only 2 blocks:
 1 . A [PropertyGroup]( https://docs.microsoft.com/en-us/visualstudio/msbuild/propertygroup-element-msbuild?view=vs-2019) element creating the following properties:
  * DebugDataPath - Indicating the location where the .pdb and .map of will be output (by default). If you are a professional software company with clients, you would want to save these.
  * RuntimePath - Where the binary outputs will go (by default). Where you would setup your test environment to run your binaries on.
2. An [ImportGroup]( https://docs.microsoft.com/en-us/visualstudio/msbuild/importgroup-element?view=vs-2019) element, where it will have additional [Import]( https://docs.microsoft.com/en-us/visualstudio/msbuild/import-element-msbuild?view=vs-2019) to import "repoLocation.props" files from either the current repository or other repositories imported as a git submodule.
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
		<Import Project="$(MSBuildThisFileDirectory)repoLocations.props" />
<!-- Other git submodules locations-->
	</ImportGroup>
</Project>
```
Please take advantage of [MSBuild well known properties](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-reserved-and-well-known-properties?view=vs-2019) for a proper configuration.

### repoLocations.props
The purpose of this file is to pass information about the location of projects available in your source control repository (especially important in a multi repository system). You can place this file at the top level of your repository, but it not need be, this file can be placed anywhere else. It should be the responsibility of the external repository that imports the current repository to provide a "locations.props" file to their projects and encode the right location of the "repoLocations.props". (Note that the file may not even be named repoLocations.props)
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

### Projects .include.props and .import.props
If you created a new library using the templates you will notice 2 files, *.include.props and *.import.props.
These files are to be used by other projects that may include this as a dependency.
The *.import.props adds the "additional include directories" of this project into other projects (that add this one as a dependency) and adds a link dependency.
The *.include.props only adds the "additional include directories".

## Extensions
Compilers as of yet do not have a common way of declaring interfaces that can be imported or exported from dynamically linked libraries. In order to support multi-platform, I provided an "extension/dll_api_macros.h" with the macros "DLL_IMPORT" and "DLL_EXPORT" for that purpose.

## Requirements
Visual studio 2022 version 17.0.0 preview 2 or higher
MSBuild with build tools version 16.6 or higher

Although technically you only need the tools you intend to use, it is recommend that you have at least the MSVC toolset and the "Linux development with C++" toolset to take advantage of this.
If you want to use it with clang you can do that too, it should work, but I haven't put in much time to support clang.

## Building the templates
You will require the "Visual Studio extension development" toolset installed to be able to compile it. Once that is done you should be able to build the solution in "quickTemplates", and then run the generated binary to install the new project templates into your Visual Studio.

## Future plans
Update the clang compiler configurations to have a build setup in the same spirit of what's already in place for MSVC and g++

On a far future ahead. I intend to extend the toolset to be able to compile using g++ and MSBuild on Linux natively (i.e. without using ssh or WSL). Although this is technically feasible with the existing tool sets, the scripts to do so haven't been written yet.
