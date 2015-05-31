include Java

require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.material.Material,
            com.jme3.scene.Geometry,
            com.jme3.scene.shape.Box,
            com.jme3.math.ColorRGBA

class HelloUpdateLoop < SimpleApplication

  def simpleInitApp
    # this blue box is our player character
    box = Box.new(1, 1, 1)
    @player = Geometry.new("blue cube", box)

    mat = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
    mat.setColor("Color", ColorRGBA::Blue)
    @player.setMaterial(mat)
    rootNode.attachChild(@player)
  end

  def simpleUpdate aNumber
    @player.rotate(0, 2 * aNumber, 0)
  end

end

HelloUpdateLoop.new.start