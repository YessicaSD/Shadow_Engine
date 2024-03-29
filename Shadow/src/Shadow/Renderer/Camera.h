#pragma once
#include "glm/glm.hpp"

NAMESPACE_BEGAN
class Camera
{
public:
	Camera(float fov = 45.0f, float aspectRatio = 1600.0f/ 900.0f , float nearPlan = 0.1f, float farPlane = 10000.0f);
	
	//Setters
	void SetOrbit(glm::vec3 lookPosition = {0,0,0});
	
	void SetPosition(const glm::vec3 position);
	void SetRotation(glm::vec3 rotation);

	//Getters
	glm::vec3 GetPosition() const { return position; };
	glm::vec3 GetRotation()const { return rotation; };
	inline glm::vec3 GetRight() const  {return right; };
	inline glm::vec3 GetUp() const  {return up; };
	inline glm::vec3 GetForward() const  {return forward; };

	glm::mat4 GetProjectViewMatrix() const;
	glm::mat4 GetViewMatrix() const;
	glm::mat4 GetProjectionMatrix() const;

	void OnImGuiRender();

	void CameraUpdatedInput();

private:
	void UpdateViewTransformation();
	void UpdateViewTransformOrbit();
	void UpdateViewTransformationLookAround();

private:
	bool orbit = false;

	glm::mat4 viewMatrix;
	glm::mat4 projectionMatrix;
	glm::mat4 viewProjMatrix;

	glm::vec3 position = {6.959,2.826,5.760};
	glm::vec3 rotation = {-13.994,221.99,0.047};

	//float pitch, yaw, roll;

	glm::vec3 forward	= {0,0,1};
	glm::vec3 right		= {1,0,0};
	glm::vec3 up		= {0,1,0};

	glm::vec3 lookPosition = {0,0,0};

};
NAMESPACE_END