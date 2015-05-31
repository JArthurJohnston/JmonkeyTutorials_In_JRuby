include Java
require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.asset.plugins.ZipLocator,
            com.jme3.bullet.BulletAppState,
            com.jme3.bullet.collision.shapes.CapsuleCollisionShape,
            com.jme3.bullet.collision.shapes.CollisionShape,
            com.jme3.bullet.control.CharacterControl,
            com.jme3.bullet.control.RigidBodyControl,
            com.jme3.bullet.util.CollisionShapeFactory,
            com.jme3.input.KeyInput,
            com.jme3.input.controls.ActionListener,
            com.jme3.input.controls.KeyTrigger,
            com.jme3.light.AmbientLight,
            com.jme3.light.DirectionalLight,
            com.jme3.math.ColorRGBA,
            com.jme3.math.Vector3f,
            com.jme3.scene.Node,
            com.jme3.scene.Spatial

class HelloCollision < SimpleApplication
  include ActionListener
  field_accessor :cam,
                 :flyCam

  def initialize
    super
    @left = false
    @right = false
    @up = false
    @down = false
    @walkDirection = Vector3f.new()

    #Temporary vectors used on each frame.
    #They here to avoid instanciating new vectors on each frame
    @camDir = Vector3f.new()
    @camLeft = Vector3f.new()
  end

  def simpleInitApp
    # Set up Physics */
    @bulletAppState = BulletAppState.new()

    stateManager.attach(@bulletAppState)
    #@bulletAppState.getPhysicsSpace().enableDebug(assetManager)

    #We re-use the flyby camera for rotation, while positioning is handled by physics
    viewPort.setBackgroundColor(ColorRGBA.new(0.7, 0.8, 1, 1))
    flyCam.setMoveSpeed(100)
    setUpKeys()
    setUpLight()

    # We load the scene from the zip file and adjust its size.
    assetManager.registerLocator('town.zip', ZipLocator.java_class)
    @sceneModel = assetManager.loadModel('main.scene')
    @sceneModel.setLocalScale(2)

    # We set up collision detection for the scene by creating a
    # compound collision shape and a static RigidBodyControl with mass zero.
    sceneShape = CollisionShapeFactory.createMeshShape(@sceneModel)
    @landscape = RigidBodyControl.new(sceneShape, 0)
    @sceneModel.addControl(@landscape)

    # We set up collision detection for the player by creating
    # a capsule collision shape and a CharacterControl.
    # The CharacterControl offers extra settings for
    # size, stepheight, jumping, falling, and gravity.
    # We also put the player in its starting position.
    capsuleShape = CapsuleCollisionShape.new(1.5, 6, 1)
    @player = CharacterControl.new(capsuleShape, 0.05)
    @player.setJumpSpeed(20)
    @player.setFallSpeed(30)
    @player.setGravity(30)
    @player.setPhysicsLocation(Vector3f.new(0, 10, 0))

    # We attach the scene and the player to the rootnode and the physics space,
    # to make them appear in the game world.
    rootNode.attachChild(@sceneModel)
    @bulletAppState.getPhysicsSpace().add(@landscape)
    @bulletAppState.getPhysicsSpace().add(@player)
  end

  #override
  def onAction bindingString, isPressed, tpfNumber
    if bindingString.eql?('Left')
      @left = isPressed
    elsif bindingString.eql?('Right')
      @right = isPressed
    elsif bindingString.eql?('Up')
      @up = isPressed
    elsif bindingString.eql?('Jump')
      if isPressed
        @player.jump
      end
    end
  end

  #override
  def simpleUpdate tpfNumber
    @camDir.set(cam.getDirection()).multLocal(0.6)
    @camLeft.set(cam.getLeft()).multLocal(0.4)
    @walkDirection.set(0, 0, 0)
    if @left
      @walkDirection.addLocal(@camLeft)
    end
    if @right
      @walkDirection.addLocal(@camLeft.negate())
    end
    if @up
      @walkDirection.addLocal(@camDir)
    end
    if @down
      @walkDirection.addLocal(@camDir.negate())
    end
    @player.setWalkDirection(@walkDirection)
    self.cam.setLocation(@player.getPhysicsLocation())
  end

  def setUpLight
    #We add light so we see the scene
    al = AmbientLight.new()
    al.setColor(ColorRGBA::White.mult(1.3))
    rootNode.addLight(al)

    dl = DirectionalLight.new()
    dl.setColor(ColorRGBA::White)
    dl.setDirection(Vector3f.new(2.8, -2.8, -2.8).normalizeLocal())
    rootNode.addLight(dl)
  end

  def setUpKeys
    inputManager.addMapping('Left', KeyTrigger.new(KeyInput::KEY_A))
    inputManager.addMapping('Right', KeyTrigger.new(KeyInput::KEY_D))
    inputManager.addMapping('Up', KeyTrigger.new(KeyInput::KEY_W))
    inputManager.addMapping('Down', KeyTrigger.new(KeyInput::KEY_S))
    inputManager.addMapping('Jump', KeyTrigger.new(KeyInput::KEY_SPACE))
    inputManager.addListener(self, 'Left')
    inputManager.addListener(self, 'Right')
    inputManager.addListener(self, 'Up')
    inputManager.addListener(self, 'Down')
    inputManager.addListener(self, 'Jump')
  end

  private :setUpKeys,
          :setUpLight

end

HelloCollision.new.start