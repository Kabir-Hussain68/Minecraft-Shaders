#version 460 compatibility

out vec4 glcolor;	//vaColor dosent exist

void main() {
    //Same as projMat * modelMat
	gl_Position = ftransform();
	glcolor = gl_Color;
}