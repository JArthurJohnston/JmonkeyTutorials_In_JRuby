include Java

require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.material.Material,
            com.jme3.math.Vector3f,
            com.jme3.scene.Geometry,
            com.jme3.scene.shape.Box,
            com.jme3.math.ColorRGBA

class Starter < SimpleApplication

  def simpleInitApp
    b = Box.new(1, 1, 1)
    geom = Geometry.new("Box", b)
    mat = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
    mat.setColor("Color", ColorRGBA::Blue)
    geom.setMaterial(mat)
    rootNode.attachChild(geom)
  end

end
