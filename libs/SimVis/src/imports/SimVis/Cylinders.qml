import SimVis 1.0
import ShaderNodes 1.0
import ShaderNodes 1.0 as Nodes

import Qt3D.Core 2.0
import Qt3D.Render 2.0

import QtQuick 2.0 as QQ2

Entity {
    id: cylindersRoot
    property var variable: 0.0
    property alias fragmentColor: _fragmentColor.value
    property alias fragmentBuilder: _fragmentBuilder
    property alias normal: _fragmentBuilder.normal
    property alias position: _fragmentBuilder.position
    property alias transform: transform

    property CylinderData cylinderData

    Transform {
        id: transform
    }

    Material {
        id: material
        effect: Effect {
            techniques: Technique {
//                graphicsApiFilter {
//                    api: GraphicsApiFilter.OpenGL
//                    profile: GraphicsApiFilter.CoreProfile
//                    minorVersion: 2
//                    majorVersion: 3
//                }
                filterKeys: FilterKey {
                    name: "renderingStyle"
                    value: "forward"
                }
                renderPasses: RenderPass {
                    shaderProgram: ShaderProgram {
                        vertexShaderCode: loadSource("qrc:/SimVis/render/shaders/es2/cylinders.vert")
                        fragmentShaderCode: _fragmentBuilder.finalShader
                    }
                    ShaderBuilder {
                        id: _fragmentBuilder

                        material: material

                        // TODO add readonly or some other way to show that these are only for others to read
                        shaderType: ShaderBuilder.Fragment

                        // inputs
                        property ShaderNode position: ShaderNode {
                            type: "vec3"
                            name: "position"
                            result: "position"
                        }
                        property ShaderNode normal: ShaderNode {
                            type: "vec3"
                            name: "normal"
                            result: "normal"
                        }
                        property ShaderNode textureCoordinate: ShaderNode {
                            type: "vec2"
                            name: "texCoord"
                            result: "texCoord"
                        }
                        property ShaderNode normalDotCamera: ShaderNode {
                            type: "vec3"
                            name: "normalDotCamera"
                            result: "normalDotCamera"
                        }
                        sourceFile: "qrc:/SimVis/render/shaders/es2/cylinders.frag"

                        outputs: [
                            ShaderOutput {
                                id: _fragmentColor
                                type: "vec4"
                                name: "fragColor"
                                value: StandardMaterial { }
                            }
                        ]
                    }
                }
            }
        }
    }

    GeometryRenderer {
        id: cylindersMeshInstanced
        primitiveType: GeometryRenderer.TriangleStrip
        enabled: instanceCount != 0
        instanceCount: cylinderData ? cylinderData.count : 0

        geometry: PointGeometry {
            attributes: [
                Attribute {
                    name: "vertex1Position"
                    attributeType: Attribute.VertexAttribute
                    vertexBaseType: Attribute.Float
                    vertexSize: 3
                    byteOffset: 0
                    byteStride: (3 + 3 + 1 + 1) * 4
                    divisor: 1
                    buffer: cylinderData ? cylinderData.buffer : null
                },
                Attribute {
                    name: "vertex2Position"
                    attributeType: Attribute.VertexAttribute
                    vertexBaseType: Attribute.Float
                    vertexSize: 3
                    byteOffset: 3 * 4
                    byteStride: (3 + 3 + 1 + 1) * 4
                    divisor: 1
                    buffer: cylinderData ? cylinderData.buffer : null
                },
                Attribute {
                    name: "radius1"
                    attributeType: Attribute.VertexAttribute
                    vertexBaseType: Attribute.Float
                    vertexSize: 1
                    byteOffset: 6 * 4
                    byteStride: (3 + 3 + 1 + 1) * 4
                    divisor: 1
                    buffer: cylinderData.buffer
                },
                Attribute {
                    name: "radius2"
                    attributeType: Attribute.VertexAttribute
                    vertexBaseType: Attribute.Float
                    vertexSize: 1
                    byteOffset: 7 * 4
                    byteStride: (3 + 3 + 1 + 1) * 4
                    divisor: 1
                    buffer: cylinderData ? cylinderData.buffer : null
                }
            ]
        }
    }

    components: [
        cylindersMeshInstanced,
        material,
        transform,
        objectPicker
    ]

    ObjectPicker {
        id: objectPicker
        dragEnabled: true
        hoverEnabled: true
        onClicked: console.log("clicked")
//                    onPressed: root.pressed(pick)
//                    onReleased: root.released(pick)
        onEntered: console.log("entered")
        onExited: console.log("exited")
    }
}
