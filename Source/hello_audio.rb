include Java
require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.audio.AudioNode,
            com.jme3.input.MouseInput,
            com.jme3.input.controls.ActionListener,
            com.jme3.input.controls.MouseButtonTrigger,
            com.jme3.material.Material,
            com.jme3.math.ColorRGBA,
            com.jme3.scene.Geometry,
            com.jme3.scene.shape.Box

class HelloAudio < SimpleApplication
  field_accessor :flyCam,
                 :cam

  #override
  def simpleInitApp
    flyCam.setMoveSpeed(40);

    # just a blue box floating in space
    box1 = Box.new(1, 1, 1);
    @player = Geometry.new("Player", box1);
    mat1 = Material.new(assetManager,"Common/MatDefs/Misc/Unshaded.j3md");
    mat1.setColor("Color", ColorRGBA::Blue);
    @player.setMaterial(mat1);
    rootNode.attachChild(@player);

    # custom init methods, see below
    initKeys();
    initAudio();
  end

  def initAudio
    #gun shot sound is to be triggered by a mouse click.
    @audio_gun = AudioNode.new(assetManager, "Sound/Effects/Gun.wav", false);
    @audio_gun.setPositional(false);
    @audio_gun.setLooping(false);
    @audio_gun.setVolume(2);
    rootNode.attachChild(@audio_gun);

    #nature sound - keeps playing in a loop.
    @audio_nature = AudioNode.new(assetManager, "Sound/Environment/Ocean Waves.ogg", true);
    @audio_nature.setLooping(true);  # activate continuous playing
    @audio_nature.setPositional(true);
    @audio_nature.setVolume(3);
    rootNode.attachChild(@audio_nature);
    @audio_nature.play(); # play continuously!
  end

  def initKeys
    inputManager.addMapping("Shoot", MouseButtonTrigger.new(MouseInput::BUTTON_LEFT));
    inputManager.addListener(shootActionListener, 'Shoot');
  end

  def shootActionListener
    return ActionListener.impl do
      |command, actionName, isKeyPressed, tpfNumber|
      case command
        when :onAction
          if actionName.eql?('Shoot') && !isKeyPressed
            @audio_gun.playInstance()
          end
      end
    end
  end

  #override
  def simpleUpdate tpfNumber
    listener.setLocation(cam.getLocation());
    listener.setRotation(cam.getRotation());
  end

  private :shootActionListener,
          :initKeys,
          :initAudio
end

# puts ActionListener.class.name

HelloAudio.new.start