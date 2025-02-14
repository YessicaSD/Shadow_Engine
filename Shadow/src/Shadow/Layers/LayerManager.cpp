#include "swpch.h"
#include "LayerManager.h"

Shadow::LayerManager::LayerManager()
{
	
}

Shadow::LayerManager::~LayerManager()
{
	for (Layer* layer : layers)
		delete layer;
}

void Shadow::LayerManager::PushLayer(Layer* layer)
{
	layers.emplace(layers.begin() + layerInsertIndex, layer);
	layerInsertIndex++;
}

void Shadow::LayerManager::PushOverlay(Layer* overlay)
{
	layers.emplace_back(overlay);
}

void Shadow::LayerManager::PopLayer(Layer* layer)
{
	auto it = std::find(layers.begin(), layers.end(), layer);
	if (it != layers.end())
	{
		layers.erase(it);
		layerInsertIndex--;
	}
}

void Shadow::LayerManager::PopOverlay(Layer* overlay)
{
	auto it = std::find(layers.begin(), layers.end(), overlay);
	if (it != layers.end())
	{
		layers.erase(it);
	}
}
