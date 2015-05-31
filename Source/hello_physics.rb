include Java

require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.asset.TextureKey,
            com.jme3.bullet.BulletAppState,
            com.jme3.bullet.control.RigidBodyControl,
            com.jme3.font.BitmapText,
            com.jme3.input.MouseInput,
            com.jme3.input.controls.ActionListener,
            com.jme3.input.controls.MouseButtonTrigger,
            com.jme3.material.Material,
            com.jme3.math.Vector2f,
            com.jme3.math.Vector3f,
            com.jme3.scene.Geometry,
            com.jme3.scene.shape.Box,
            com.jme3.scene.shape.Sphere,
            com.jme3.scene.shape.Sphere::TextureMode,
            com.jme3.texture.Texture,
            com.jme3.texture.Texture::WrapMode

class HelloPhysics < SimpleApplication
  field_accessor :cam,
                 :settings

  class << self
    @@brickLength = 0.4
    @@brickWidth = 0.24
    @@brickHeight = 0.12

    @@sphere = Sphere.new(32, 32, 0.4, true, false)
    @@sphere.setTextureMode(TextureMode::Projected)
    #Initialize the brick geometry */
    @@box = Box.new(@@brickLength, @@brickHeight, @@brickWidth)
    @@box.scaleTextureCoordinates(Vector2f.new(1, 0.5))
    #Initialize the floor geometry */
    @@floor = Box.new(10, 0.1, 5)
    @@floor.scaleTextureCoordinates(Vector2f.new(3, 6))
  end

  #override
  def simpleInitApp
    #Set up Physics Game */
    @bulletAppState = BulletAppState.new()
    stateManager.attach(@bulletAppState)
    #@bulletAppState.getPhysicsSpace().enableDebug(assetManager)

    #Configure cam to look at scene */
    cam.setLocation(Vector3f.new(0, 4, 6))
    cam.lookAt(Vector3f.new(2, 2, 0), Vector3f::UNIT_Y)
    #Add InputManager action: Left click triggers shooting.
    inputManager.addMapping('shoot',MouseButtonTrigger.new(MouseInput::BUTTON_LEFT))
    inputManager.addListener(shootActionListener, 'shoot')
    #Initialize the scene, materials, and physics space
    initMaterials()
    initWall()
    initFloor()
    initCrossHairs()
  end

  #Initialize the materials used in this scene.
  def initMaterials
    @wall_mat = Material.new(assetManager, 'Common/MatDefs/Misc/Unshaded.j3md')
    key = TextureKey.new('Textures/Terrain/BrickWall/BrickWall.jpg')
    key.setGenerateMips(true)
    tex = assetManager.loadTexture(key)
    @wall_mat.setTexture('ColorMap', tex)

    @stone_mat = Material.new(assetManager, 'Common/MatDefs/Misc/Unshaded.j3md')
    key2 = TextureKey.new('Textures/Terrain/Rock/Rock.PNG')
    key2.setGenerateMips(true)
    tex2 = assetManager.loadTexture(key2)
    @stone_mat.setTexture('ColorMap', tex2)

    @floor_mat = Material.new(assetManager, 'Common/MatDefs/Misc/Unshaded.j3md')
    key3 = TextureKey.new('Textures/Terrain/Pond/Pond.jpg')
    key3.setGenerateMips(true)
    tex3 = assetManager.loadTexture(key3)
    tex3.setWrap(WrapMode::Repeat)
    @floor_mat.setTexture('ColorMap', tex3)
  end

  #Make a solid floor and add it to the scene.
  def initFloor
    floor_geo = Geometry.new('Floor', @@floor)
    floor_geo.setMaterial(@floor_mat)
    floor_geo.setLocalTranslation(0, -0.1, 0)
    self.rootNode.attachChild(floor_geo)
    #Make the floor physical with mass 0.0f! */
    @floor_phy = RigidBodyControl.new(0.0)
    floor_geo.addControl(@floor_phy)
    @bulletAppState.getPhysicsSpace().add(@floor_phy)
  end

  #This loop builds a wall out of individual bricks.
  def initWall
    startPoint = @@brickLength / 4
    height = 0
    for j in 0..14 do
      for i in 0..5 do
        vt = Vector3f.new(i * @@brickLength * 2 + startPoint, @@brickHeight + height, 0)
        makeBrick(vt)
      end
      startPoint = -startPoint
      height += 2 * @@brickHeight
    end
  end

  #This method creates one individual physical brick.
  def makeBrick(locationVector)
    #Create a brick geometry and attach to scene graph. */
    brick_geo = Geometry.new('brick', @@box)
    brick_geo.setMaterial(@wall_mat)
    rootNode.attachChild(brick_geo)
    #Position the brick geometry  */
    brick_geo.setLocalTranslation(locationVector)
    #Make brick physical with a mass > 0.0f. */
    @brick_phy = RigidBodyControl.new(2)
    #Add physical brick to physics space. */
    brick_geo.addControl(@brick_phy)
    @bulletAppState.getPhysicsSpace().add(@brick_phy)
  end

  # This method creates one individual physical cannon ball.
  # By defaul, the ball is accelerated and flies
  # from the camera position in the camera direction.\
  def makeCannonBall
    # Create a cannon ball geometry and attach to scene graph. */
    ball_geo = Geometry.new('cannon ball', @@sphere)
    ball_geo.setMaterial(@stone_mat)
    rootNode.attachChild(ball_geo)
    # Position the cannon ball  */
    ball_geo.setLocalTranslation(cam.getLocation())
    # Make the ball physcial with a mass > 0.0f */
    @ball_phy = RigidBodyControl.new(1)
    # Add physical ball to physics space. */
    ball_geo.addControl(@ball_phy)
    @bulletAppState.getPhysicsSpace().add(@ball_phy)
    # Accelerate the physcial ball to shoot it. */
    @ball_phy.setLinearVelocity(cam.getDirection().mult(25))
  end

  #A plus sign used as crosshairs to help the player with aiming
  def initCrossHairs
    guiNode.detachAllChildren()
    guiFont = assetManager.loadFont('Interface/Fonts/Default.fnt')
    ch = BitmapText.new(guiFont, false)
    ch.setSize(guiFont.getCharSet().getRenderedSize() * 2)
    ch.setText('+')        # fake crosshairs :)
    ch.setLocalTranslation(settings.getWidth() / 2 - guiFont.getCharSet().getRenderedSize() / 3 * 2,
        settings.getHeight() / 2 + ch.getLineHeight() / 2, 0)
    guiNode.attachChild(ch)
  end

  def shootActionListener
    return ActionListener.impl do
      |command, actionString, isKeyPressed, tpfNumber|
      case command
        when :onAction
          if (actionString.eql?('shoot') && !isKeyPressed)
              makeCannonBall()
          end
      end
    end
  end

  private :shootActionListener
end

HelloPhysics.new.start