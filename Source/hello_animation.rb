include Java

require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.animation.AnimChannel,
            com.jme3.animation.AnimControl,
            com.jme3.animation.AnimEventListener,
            com.jme3.animation.LoopMode,
            com.jme3.app.SimpleApplication,
            com.jme3.input.KeyInput,
            com.jme3.input.controls.ActionListener,
            com.jme3.input.controls.KeyTrigger,
            com.jme3.light.DirectionalLight,
            com.jme3.math.ColorRGBA,
            com.jme3.math.Vector3f,
            com.jme3.scene.Node

class HelloAnimation < SimpleApplication
  include AnimEventListener

  WALK = 'Walk'
  STAND = 'stand'

  def simpleInitApp
    viewPort.setBackgroundColor(ColorRGBA::LightGray)
    initKeys()
    dl = DirectionalLight.new()
    dl.setDirection(Vector3f.new(-0.1, -1, -1).normalizeLocal())
    rootNode.addLight(dl)
    @player = assetManager.loadModel('Models/Oto/Oto.mesh.xml')
    @player.setLocalScale(0.5)
    rootNode.attachChild(@player)
    @control = @player.getControl(AnimControl.java_class)
    @control.addListener(self)
    @channel = @control.createChannel()
    @channel.setAnim(STAND)
  end

  def onAnimCycleDone(control, channel, animName)
    if animName.eql? WALK
      channel.setAnim(STAND, 0.50)
      channel.setLoopMode(LoopMode::DontLoop)
      channel.setSpeed(1)
    end
  end

  def onAnimChange(control, channel, animName)
  #   unused
  end

  def initKeys
    inputManager.addMapping(WALK, KeyTrigger.new(KeyInput::KEY_SPACE))
    inputManager.addListener(walkActionListener, WALK)
  end

  def walkActionListener
    return ActionListener.impl do
      |command, nameString, keyPressed, aNumber|
      case command
        when :onAction
          if nameString.eql?(WALK) && keyPressed.eql?(false)
            @channel.setAnim(WALK, 0.50)
            @channel.setLoopMode(LoopMode::Loop)
          end
      end
    end
  end
end

# puts AnimControl.new.class.to_s
HelloAnimation.new.start