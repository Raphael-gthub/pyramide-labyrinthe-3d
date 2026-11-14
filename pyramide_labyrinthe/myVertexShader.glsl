#ifdef GL_ES
precision mediump float;
#endif

// Built-in attributes
attribute vec4 vertex;
attribute vec3 normal;
attribute vec2 texCoord;

// Uniforms de Processing
uniform mat4 transform;   // modelview-projection matrix
uniform mat3 normalMatrix;

// Pour le fragment shader
varying vec3 vNormal;
varying vec3 vPosition;
varying vec2 vTexCoord;

void main() {

  vec4 pos = transform * vertex;
  gl_Position = pos;
  vPosition = pos.xyz;
  

  vNormal = normalize(normalMatrix * normal);
  

  vTexCoord = texCoord;
}
