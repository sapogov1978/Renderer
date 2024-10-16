workspace "renderer"
	architecture "x64"
	startproject "renderer"

	configurations
	{
		"Debug",
		"Release",
		"Distribution"
	}

	flags
	{
		"MultiProcessorCompile"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}

group "Dependencies"
group ""

-- Function to add compiler warnings
function AddCompilerWarnings()
	filter "system:windows"
		buildoptions
		{
			"/utf-8",
			"/w44265",                         -- Somewhat equivalent to -Wextra
			"/permissive-",                    -- Equivalent to -Wpedantic
			"/w44263",                         -- Equivalent to -Wctor-dtor-privacy
			"/w44862",                         -- Equivalent to -Wnon-virtual-dtor
			"/w44271",                         -- Equivalent to -Wold-style-cast
			"/w44459",                         -- Equivalent to -Woverloaded-virtual
			"/w44263",                         -- Equivalent to -Wsign-promo
			"/w44860",                         -- Equivalent to -Wduplicated-branches
			"/w44861",                         -- Equivalent to -Wduplicated-cond
			"/w44265",                         -- Equivalent to -Wfloat-equal
			"/w44267",                         -- Equivalent to -Wshadow=compatible-local
			"/w44266",                         -- Equivalent to -Wcast-qual
			"/w44265",                         -- Equivalent to -Wconversion
			"/w44268",                         -- Equivalent to -Wzero-as-null-pointer-constant
			"/w44266",                         -- Equivalent to -Wextra-semi
			"/w44472",                         -- Equivalent to -Wsign-conversion
			"/w44262",                         -- Equivalent to -Wlogical-op
		}

	filter "system:linux"
		buildoptions
		{
			"-Wall",                           -- Enable most common warnings
			"-Wextra",                         -- Even more common errors will be checked
			"-Wpedantic",                      -- And moooore
			"-Wctor-dtor-privacy",             -- Check if class with private constructor is used by any friends
			"-Wnon-virtual-dtor",              -- If you have virtual member funcs - don’t forget to have virtual ~
			"-Woverloaded-virtual",            -- We don’t overload virtual funcs, only overriding
			"-Wsign-promo",                    -- Overloading is not really accurate
			"-Wduplicated-cond",               -- Same, but with else if
			"-Wfloat-equal",                   -- Warning for float comparison
			"-Wshadow=compatible-local",       -- Shadowing warnings for local variables
			"-Wcast-qual",                     -- Warning for const qualification casts
			"-Wconversion",                    -- Warning for implicit type conversions
			"-Wextra-semi",                    -- Extra semicolon warnings
			"-Wlogical-op",                    -- Warning for logical operations
			"-Werror",                         -- Treat warnings as errors
			"-pedantic-errors"                 -- Treat pedantic warnings as errors
		}
end

-- Function to add common configurations
function AddCommonConfigurations()
	filter "configurations:Debug"
		symbols "on"
		runtime "Debug"

	filter "configurations:Release"
		symbols "on"
		optimize "on"
		runtime "Release"

	filter "configurations:Distribution"
		symbols "on"
		optimize "on"
		runtime "Release"
end

-- JourneyEngine Project
project "renderer"
	location "renderer"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++20"
	staticruntime "on"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}

	includedirs
	{
		"%{prj.name}/src"
		}

	filter "system:windows"
		systemversion "latest"
		defines
		{
			"TST_BLOCK_FOR_PROJECT_DEFINES"
		}

	filter "system:linux"
		links 
		{
			-- Here adds linking dependencies
		}

	AddCompilerWarnings()
	AddCommonConfigurations()