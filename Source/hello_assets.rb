include Java

require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.material.Material,
            com.jme3.math.Vector3f,
            com.jme3.scene.Geometry,
            com.jme3.scene.shape.Box,
            com.jme3.math.ColorRGBA,
            com.jme3.light.DirectionalLight,
            com.jme3.font.BitmapText

class HelloAssets < SimpleApplication

  def simpleInitApp
    teapot = assetManager.loadModel("Models/Teapot/Teapot.obj")
    mat_default = Material.new(assetManager, "Common/MatDefs/Misc/ShowNormals.j3md")
    teapot.setMaterial(mat_default)
    rootNode.attachChild(teapot)

    # Create a wall with a simple texture from test_data

    box = Box.new(2.5, 2.5, 1.0)
    wall = Geometry.new("Box", box )
    mat_brick = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
    mat_brick.setTexture("ColorMap",
                         assetManager.loadTexture("Textures/Terrain/BrickWall/BrickWall.jpg"))
    wall.setMaterial(mat_brick)
    wall.setLocalTranslation(2.0, -2.5, 0.0)
    rootNode.attachChild(wall)

    # Display a line of text with a default font

    guiNode.detachAllChildren()
    guiFont = assetManager.loadFont("Interface/Fonts/Default.fnt")
    helloText = BitmapText.new(guiFont, false)
    helloText.setSize(guiFont.getCharSet().getRenderedSize())
    helloText.setText("Hello World")
    helloText.setLocalTranslation(300, helloText.getLineHeight(), 0)
    guiNode.attachChild(helloText)

     # Load a model from test_data (OgreXML + material + texture)
    ninja = assetManager.loadModel("Models/Ninja/Ninja.mesh.xml")
    ninja.scale(0.05, 0.05, 0.05)
    ninja.rotate(0.0, -3.0, 0.0)
    ninja.setLocalTranslation(0.0, -5.0, -2.0)
    rootNode.attachChild(ninja)

    # // You must add a light to make the model visible
    sun = DirectionalLight.new()
    sun.setDirection(Vector3f.new(-0.1, -0.7, -1.0))
    rootNode.addLight(sun)
  end
end

HelloAssets.new.start