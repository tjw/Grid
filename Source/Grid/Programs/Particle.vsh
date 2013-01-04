uniform mat4 MVP;
attribute vec4 position;

void main()
{
    gl_PointSize = 8.0;
    gl_Position = MVP * position;
}
