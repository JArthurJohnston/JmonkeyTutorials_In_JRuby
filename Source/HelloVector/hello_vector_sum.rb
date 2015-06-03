include Java

require_relative '../lib/jMonkeyEngine3.jar'
require_relative 'spatial_utils'
require_relative 'debug'
require_relative 'material_utils'

java_import com.jme3.app.SimpleApplication,
            com.jme3.material.Material,
            com.jme3.math.ColorRGBA,
            com.jme3.math.Vector3f,
            com.jme3.renderer.RenderManager,
            com.jme3.scene.Geometry,
            com.jme3.scene.Node,
            com.jme3.scene.shape.Box

class HelloVectorSum < SimpleApplication
  field_accessor :cam,
                 :flyCam

  #override
  def simpleInitApp
    cam.setLocation(camLocVctr)
    cam.lookAt(Vector3f::ZERO, cam.getUp())
    flyCam.setMoveSpeed(100.0)

    Debug.showNodeAxes(assetManager, rootNode, 128)
    Debug.attachWireFrameDebugGrid(assetManager, rootNode, Vector3f::ZERO, 256, ColorRGBA::DarkGray)

    box = Box.new(1, 1, 1)

    mat = MaterialUtils.makeMaterial(assetManager, "Common/MatDefs/Misc/Unshaded.j3md", ColorRGBA::Blue)
    geom = SpatialUtils.makeGeometryWithScaleAtLocation(vctrNodeSpatLoc, scale, box, mat, "box")
    vctrNode.attachChild(geom)
    vctrNode.setLocalTranslation(vctrNodeLoc)
    vctrSumm = vctrNodeLoc.add(vctrNodeSpatLoc)

    Debug.showNodeAxes(assetManager, vctrNode, 4.0)
    Debug.showVector3fArrow(assetManager, rootNode, vctrNodeLoc, ColorRGBA::Red, "vctrNodeLoc")
    Debug.showVector3fArrow(assetManager, vctrNode, vctrNodeSpatLoc, ColorRGBA::Green, "vctrNodeSpatLoc")
    Debug.showVector3fArrow(assetManager, rootNode, vctrSumm, ColorRGBA::Blue, "vctrSumm")

    rootNode.attachChild(vctrNode)
  end

  #override
  def simpleUpdate tpfNumber

  end

  #override
  def simpleRender aRenderManager

  end

end

HelloVectorSum.new.start