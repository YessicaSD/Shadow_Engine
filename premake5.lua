workspace "Shadow"
    architecture "x64"
   configurations { "Debug", "Release", "Dist"}

   outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

   IncludeDir = {}
   IncludeDir["GLFW"] = "Shadow/vendor/GLFW/include"

   include "Shadow/vendor/GLFW"
project "Shadow"
    location "Shadow"
    kind "sharedLib"
    language "C++"

   targetdir ("bin/" .. outputdir .. "/%{prj.name}")
   objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
   
   pchheader "swpch.h"
   pchsource "Shadow/src/swpch.cpp"

   files 
   { 
       "%{prj.name}/src/**.h",
       "%{prj.name}/src/**.cpp",
   }

   includedirs
   {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        IncludeDir.GLFW,
   }
   links{
       "GLFW",
       "opengl32.lib"
   }
    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"
        defines 
        { 
            "SW_PLATFORM_WINDOWS",
            "SW_BUILD_DLL"
        }
    
    postbuildcommands
    {
        ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir.. "/Sandbox")
	}

   filter "configurations:Debug"
      defines "SW_DEBUG"
      symbols "On"

   filter "configurations:Release"
      defines "SW_RELEASE"
      optimize "On"

   filter "configurations:Dist"
      defines "SW_DIST"
      optimize "On"

 project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    
    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
   

     files 
   { 
       "%{prj.name}/src/**.h",
       "%{prj.name}/src/**.cpp",
   }

   includedirs 
   {
        "Shadow/vendor/spdlog/include",
        "Shadow/src"
   }

   links 
   {
       "Shadow"
   }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"
        defines 
        { 
            "SW_PLATFORM_WINDOWS" 
        }
    
   filter "configurations:Debug"
      defines "SW_DEBUG"
      symbols "On"

   filter "configurations:Release"
      defines "SW_RELEASE"
      optimize "On"

   filter "configurations:Dist"
      defines "SW_DIST"
      optimize "On"

   