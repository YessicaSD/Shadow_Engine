#pragma once

#include "Core.h"
#include "swpch.h"
#include "Window.h"
#include "Layers/LayerManager.h"
#include "Event/Event.h"

#include "Event/EventApplication.h"

NAMESPACE_BEGAN

class SHADOW_API Application
{
	public:
		Application();
		virtual ~Application();

		void Run();

		void OnEvent(Event& e);

		void PushLayer(Layer* layer);
		void PushOverlay(Layer* layer);
		
		inline static Application& Get() { return *app; }
		inline Window& GetWindow() { return *window; }

	private:
		bool OnWindowClosed(WindowCloseEvent& e);

	private:
		bool running = true;
		std::unique_ptr<Window> window;
		LayerManager layerManager;
		static Application* app;
};

	// This function is going to be defined by the CLIENT
	Application* CreateApplication();
	
NAMESPACE_END
