typedef enum {
    VertexAttribPosition = 0,
    VertexAttribColor,
    VertexAttribTexCoord,
    VertexAttribNormal
} VertexAttributes;

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
    float Normal[3];
} Vertex;