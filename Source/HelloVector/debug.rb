require_relative 'material_utils'
require_relative 'spatial_utils'

class Debug

  class << self

    def showNodeAxes assetManager, node, axisLength
      node.attachChild(createVectorOnAxisWithColor('XAxis', ColorRGBA::Red))
      node.attachChild(createVectorOnAxisWithColor('YAxis', ColorRGBA::Green))
      node.attachChild(createVectorOnAxisWithColor('ZAxis', ColorRGBA::Blue))
    end

    def createVectorOnAxisWithColor axisLabel, color
      vector = Vector3f.new(axisLen, 0, 0)
      arrow = Arrow.new(vector)
      mat = Material.new(am, "Common/MatDefs/Misc/Unshaded.j3md")
      mat.setColor("Color", color)
      geom = Geometry.new(n.getName() + axisLabel, arrow)
      geom.setMaterial(mat)
      return vector
    end

    def showObjectWith object, assetManager, node, vector, color, name
      material = MaterialUtils.makeMaterial(assetManager, "Common/MatDefs/Misc/Unshaded.j3md", color)
      geom = SpatialUtils.makeGeometry(object, material, name)
      node.attachChild(geom)
    end

    def showVector3fArrow assetManager, node, vector, color, name
      arrow = Arrow.new(vector)
      showObjectWith arrow, assetManager, node, vector, color, name
    end

    def showVector3fLine assetManager, node, vector, color, name
      line = Line.new(vector.subtract(vector), vector)
      showObjectWith line, assetManager, node, vector, color, name
    end

    def attachSkeleton assetManager, node, animControl
      skeletonDebug = SkeletonDebugger.new("skeleton", animControl.getSkeleton())
      material = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
      material.setColor("Color", ColorRGBA::Yellow)
      material.getAdditionalRenderState().setDepthTest(false)
      skeletonDebug.setMaterial(material)
      node.attachChild(skeletonDebug)
    end

    def attachWireFrameDebugGrid assetManager, node, positionVector, size, color
      geometry = Geometry.new("wireFrameDebugGrid", Grid.new(size, size, 1.0))  #1 work unit
      material = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
      material.getAdditionalRenderState().setWireframe(true)
      material.setColor("Color", color)
      geometry.setMaterial(material)
      geometry.center().move(positionVector)
      node.attachChild(geometry)
    end

    private_class_method :showObjectWith,
        :createVectorOnAxisWithColor

  end

end