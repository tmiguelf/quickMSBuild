rmdir "output" -Recurse -Force
mkdir "output/" -Force
copy "resources/Console Application/" "output/" -Recurse -Force
copy "resources/Windows Application/" "output/" -Recurse -Force
copy "resources/Dynamic Library/" "output/" -Recurse -Force
copy "resources/Static Library/" "output/" -Recurse -Force
copy "resources/Utility/" "output/" -Recurse -Force
copy "resources/Google Benchmark/" "output/" -Recurse -Force
copy "resources/Google Test/" "output/" -Recurse -Force

copy "resources/generic.ico" "output/Console Application/__TemplateIcon.ico" -Force
copy "resources/generic.ico" "output/Windows Application/__TemplateIcon.ico" -Force
copy "resources/generic.ico" "output/Dynamic Library/__TemplateIcon.ico" -Force
copy "resources/generic.ico" "output/Static Library/__TemplateIcon.ico" -Force
copy "resources/generic.ico" "output/Utility/__TemplateIcon.ico" -Force
copy "resources/generic.ico" "output/Google Benchmark/__TemplateIcon.ico" -Force
copy "resources/generic.ico" "output/Google Test/__TemplateIcon.ico" -Force

mkdir "output/Console Application/resources" -Force
mkdir "output/Windows Application/resources" -Force
mkdir "output/Dynamic Library/resources" -Force
mkdir "output/Dynamic Library/src" -Force
mkdir "output/Static Library/include" -Force
mkdir "output/Static Library/include/lib" -Force
mkdir "output/Static Library/src" -Force
mkdir "output/Utility/include" -Force
mkdir "output/Utility/include/lib" -Force


copy "resources/generic.ico" "output/Console Application/resources/generic.ico" -Force
copy "resources/generic.ico" "output/Windows Application/resources/generic.ico" -Force

copy "resources/resources/genericIcon.rc" "output/Console Application/resources/genericIcon.rc" -Force
copy "resources/resources/genericIcon.rc" "output/Windows Application/resources/genericIcon.rc" -Force
copy "resources/resources/dllVersion.rc" "output/Dynamic Library/resources/dllVersion.rc" -Force

copy "resources/resources/versionSpecific.h" "output/Console Application/resources/versionSpecific.h" -Force
copy "resources/resources/versionSpecific.h" "output/Windows Application/resources/versionSpecific.h" -Force
copy "resources/resources/versionSpecific.h" "output/Dynamic Library/resources/versionSpecific.h" -Force

copy "resources/empty.hpp" "output/Dynamic Library/include/lib/header.hpp" -Force
copy "resources/empty.hpp" "output/Static Library/include/lib/header.hpp" -Force
copy "resources/empty.hpp" "output/Utility/include/lib/header.hpp" -Force

copy "resources/empty.cpp" "output/Dynamic Library/src/src.cpp" -Force
copy "resources/empty.cpp" "output/Static Library/src/src.cpp" -Force

copy "resources/props/import.props" "output/Dynamic Library/import.props" -Force
copy "resources/props/include.props" "output/Dynamic Library/include.props" -Force

copy "resources/props/import.props" "output/Static Library/import.props" -Force
copy "resources/props/include.props" "output/Static Library/include.props" -Force

copy "resources/props/include.props" "output/Utility/include.props" -Force

mkdir "../ProjectTemplates" -Force

7z a -tzip -y "../ProjectTemplates/Console Application.zip" "output/Console Application"
7z a -tzip -y "../ProjectTemplates/Windows Application.zip" "output/Windows Application"
7z a -tzip -y "../ProjectTemplates/Dynamic Library.zip" "output/Dynamic Library"
7z a -tzip -y "../ProjectTemplates/Static Library.zip" "output/Static Library"
7z a -tzip -y "../ProjectTemplates/Utility.zip" "output/Utility"
7z a -tzip -y "../ProjectTemplates/Google Benchmark.zip" "output/Google Benchmark"
7z a -tzip -y "../ProjectTemplates/Google Test.zip" "output/Google Test"

