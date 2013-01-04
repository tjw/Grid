uniform mat4 MVP;
attribute vec4 position;
x

void main()
{
    gl_PointSize = 4;
    gl_Position = MVP * position;
}
