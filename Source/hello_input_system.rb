include Java

require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.material.Material,
            com.jme3.scene.Geometry,
            com.jme3.scene.shape.Box,
            com.jme3.math.ColorRGBA,
            com.jme3.input.KeyInput,
            com.jme3.input.MouseInput,
            com.jme3.input.controls.ActionListener,
            com.jme3.input.controls.AnalogListener,
            com.jme3.input.controls.KeyTrigger,
            com.jme3.input.controls.MouseButtonTrigger

class HelloInputSystem < SimpleApplication
  PAUSE = 'Pause'
  LEFT = 'Left'
  RIGHT = 'Right'
  ROTATE = 'Rotate'

  def simpleInitApp
    @speed = 4.0
    @isRunning = true
    # this blue box is our player character
    box = Box.new(1, 1, 1)
    @player = Geometry.new("Player", box)

    mat = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
    mat.setColor("Color", ColorRGBA::Blue)
    @player.setMaterial(mat)
    rootNode.attachChild(@player)
    initKeys() #load our custom keybindings
  end

  def initKeys
    # // You can map one or several inputs to one named action
    inputManager.addMapping(PAUSE,  KeyTrigger.new(KeyInput::KEY_P))
    inputManager.addMapping(LEFT,   KeyTrigger.new(KeyInput::KEY_J))
    inputManager.addMapping(RIGHT,  KeyTrigger.new(KeyInput::KEY_K))
    inputManager.addMapping(ROTATE, KeyTrigger.new(KeyInput::KEY_SPACE),
                              MouseButtonTrigger.new(MouseInput::BUTTON_LEFT))
    # // Add the names to the action listener.
    inputManager.addListener(pauseActionListener,PAUSE)
    inputManager.addListener(movementAnalogListener,LEFT, RIGHT, ROTATE)
  end

  def pauseActionListener
    return ActionListener.impl do
      |method, nameString, keyPressed, aNumber|
      case method
        when :onAction
          isPauseCommand = nameString.eql? PAUSE
          isKeyUp = keyPressed.equal? false
          if isPauseCommand && isKeyUp
            @isRunning = !@isRunning
          end
      end
    end
  end

  def movementAnalogListener
    return AnalogListener.impl do
      |method, nameString, valueNumber, aNumber|
      case method
        when :onAnalog
          if @isRunning
            speedValue = valueNumber * @speed
            if nameString.eql?(ROTATE)
              @player.rotate(0, speedValue, 0)
            end
            if nameString.eql?(RIGHT)
              playerLocationVector = @player.getLocalTranslation()
              @player.setLocalTranslation(playerLocationVector.x + speedValue,
                                          playerLocationVector.y,
                                          playerLocationVector.z)
            end
            if nameString.eql?(LEFT)
              playerLocationVector = @player.getLocalTranslation()
              @player.setLocalTranslation(playerLocationVector.x - speedValue,
                                          playerLocationVector.y,
                                          playerLocationVector.z)
            end
          else
            puts 'press P to unpause.'
          end
      end
    end
  end

  private :movementAnalogListener,
          :pauseActionListener,
          :initKeys
end

HelloInputSystem.new.start