#version 450

uniform float iTime;
in vec2 uv;
out vec4 fragColor;

void main() {
    fragColor = vec4(uv, 0.5 + 0.5 * sin(iTime), 1.0);
}
