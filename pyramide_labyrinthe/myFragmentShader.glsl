#ifdef GL_ES
precision mediump float;
#endif

// Uniforms
uniform sampler2D texture;    // la texture venant de Processing
uniform vec3 lightPosition;
uniform vec3 viewPosition;
uniform float shininess;      // shininess exponent
uniform vec3 specularColor;   // couleur de la lumière spéculaire
uniform vec3 ambientLight;    // lumiere ambiente

// Variables venant du vertex shader
varying vec3 vNormal;
varying vec3 vPosition;
varying vec2 vTexCoord;

void main() {

  vec3 normal = normalize(vNormal);
  
  // Direction vers la lumière
  vec3 lightDir = normalize(lightPosition - vPosition);
  
  // Diffusion simple
  float diff = max(dot(normal, lightDir), 0.0);
  
  // Direction de la vue
  vec3 viewDir = normalize(viewPosition - vPosition);
  
  // Vecteur de reflexion
  vec3 reflectDir = reflect(-lightDir, normal);
  
  // Reflection + shininess
  float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
  
  // Recupere la couleur
  vec3 texColor = texture2D(texture, vTexCoord).rgb;
  
  // Combine les lumières: ambient + diffuse + specular
  vec3 ambient = ambientLight * texColor;
  vec3 diffuse = diff * texColor;
  vec3 specular = spec * specularColor;
  
  gl_FragColor = vec4(ambient + diffuse + specular, 1.0);
}
