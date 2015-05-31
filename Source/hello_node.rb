include Java

require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.material.Material,
            com.jme3.math.Vector3f,
            com.jme3.scene.Geometry,
            com.jme3.scene.shape.Box,
            com.jme3.math.ColorRGBA,
            com.jme3.scene.Node

USHADED_MATERIAL = 'Common/MatDefs/Misc/Unshaded.j3md'
COLOR = 'Color'
BOX = 'Box'

class SceneNode < com.jme3.scene.Node
  def initialize aString
    super aString
  end
end

class HelloNode < SimpleApplication

  def simpleInitApp
    # create a blue box at coordinates (1,-1,1)
    box1 = Box.new(1,1,1)
    blueGeometry = Geometry.new(BOX, box1)
    blueGeometry.setLocalTranslation(Vector3f.new(1, -1, 1))
    mat1 = Material.new(assetManager, USHADED_MATERIAL)
    mat1.setColor(COLOR, ColorRGBA::Blue)
    blueGeometry.setMaterial(mat1)

  #   create a red box straight above the blue one at (1,3,1)
    box2 = Box.new(1,1,1)
    redGeometry = Geometry.new(BOX, box2)
    redGeometry.setLocalTranslation(Vector3f.new(1, 3, 1))
    mat2 = Material.new(assetManager, USHADED_MATERIAL)
    mat2.setColor(COLOR, ColorRGBA::Red)
    redGeometry.setMaterial(mat2)

  #   Create a pivot node at (0,0,0) and attach it to the root node
    pivot = SceneNode.new('pivot')
    rootNode.attachChild(pivot)

    pivot.attachChild(blueGeometry)
    pivot.attachChild(redGeometry)
    pivot.rotate(0.4, 0.4, 0.4)

  end
end

HelloNode.new.start