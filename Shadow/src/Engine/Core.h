#pragma once

#define NAMESPACE_BEGAN namespace Shadow {
#define NAMESPACE_END }

#ifdef SW_PLATFORM_WINDOWS
	#ifdef SW_BUILD_DLL
		#define SHADOW_API __declspec(dllexport)
	#else 
		#define SHADOW_API __declspec(dllimport)
	#endif // SW_BUILD_DLL
#else
	#error Hazel only supports Windows!
#endif // SW_PLATFORM_WINDOWS
#define SW_ENABLE_ASSERTS

//#ifdef SW_ENABLE_ASSERTS
//	// Currently accepts at least the condition and one additional parameter (the message) being optional
//	#define SW_ASSERT(x, ...)							\
//	{													\
//		if(!(x))										\
//		{ SW_ERROR("Assertion Fail: {0}", _VA_ARGS_);   \
//		_debugbreak()}									\
//	} 
//	#define SW_CORE_ASSERT(...) SW_EXPAND_MACRO( SW_INTERNAL_ASSERT_GET_MACRO(__VA_ARGS__)(_CORE_, __VA_ARGS__) )
//#else
//	#define SW_ASSERT(...)
//	#define SW_CORE_ASSERT(...)
//#endif