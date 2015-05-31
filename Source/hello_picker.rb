include Java
require_relative '../lib/jMonkeyEngine3.jar'
java_import com.jme3.app.SimpleApplication,
            com.jme3.collision.CollisionResult,
            com.jme3.collision.CollisionResults,
            com.jme3.font.BitmapText,
            com.jme3.input.KeyInput,
            com.jme3.input.MouseInput,
            com.jme3.input.controls.ActionListener,
            com.jme3.input.controls.KeyTrigger,
            com.jme3.input.controls.MouseButtonTrigger,
            com.jme3.light.DirectionalLight,
            com.jme3.material.Material,
            com.jme3.math.ColorRGBA,
            com.jme3.math.Ray,
            com.jme3.math.Vector3f,
            com.jme3.scene.Geometry,
            com.jme3.scene.Node,
            com.jme3.scene.Spatial,
            com.jme3.scene.shape.Box,
            com.jme3.scene.shape.Sphere

class HelloPicker < SimpleApplication
  field_accessor :cam,
                 :settings


  def simpleInitApp
    initCrossHairs() # a "+" in the middle of the screen to help aiming
    initKeys()      # load custom key mappings
    initMark()      # a red sphere to mark the hit

    # create four colored boxes and a floor to shoot at:
    @shootables = Node.new("Shootables")
    rootNode.attachChild(@shootables)
    @shootables.attachChild(makeCube("a Dragon", -2, 0, 1))
    @shootables.attachChild(makeCube("a tin can", 1, -2, 0))
    @shootables.attachChild(makeCube("the Sheriff", 0, 1, -2))
    @shootables.attachChild(makeCube("the Deputy", 1, 0, -4))
    @shootables.attachChild(makeFloor())
    @shootables.attachChild(makeCharacter())
  end

  def initKeys
    inputManager.addMapping("Shoot", KeyTrigger.new(KeyInput::KEY_SPACE), #trigger 1: spacebar
                        MouseButtonTrigger.new(MouseInput::BUTTON_LEFT)) # trigger 2: left-button click
    inputManager.addListener(shootActionListener(), "Shoot")
  end

  def shootActionListener
    return ActionListener.impl do
      |command, name, keyPressed, tfp|
      case command
        when :onAction
          if name.eql?('Shoot') && !keyPressed
            # 1. Reset results list.
            results = CollisionResults.new()
            # 2. Aim the ray from cam loc to cam direction.
            ray = Ray.new(self.cam.getLocation(), self.cam.getDirection())
            # 3. Collect intersections between Ray and Shootables in results list.
            @shootables.collideWith(ray, results)
            # 4. Print the results
            puts("----- Collisions? " + results.size().to_s + "-----")

            for i in 0..(results.size - 1)
              # For each hit, we know distance, impact point, name of geometry.
              distance = results.getCollision(i).getDistance()
              pt = results.getCollision(i).getContactPoint()
              hit = results.getCollision(i).getGeometry().getName()
              puts("* Collision #" + i.to_s)
              puts("  You shot " + hit.to_s + " at " + pt.to_s + ", " + distance.to_s + " wu away.")
            end
            if results.size > 0
              #The closest collision point is what was truly hit:
              closestCollision = results.getClosestCollision()
              #Let's interact - we mark the hit with a red dot.
              @mark.setLocalTranslation(closestCollision.getContactPoint())
              rootNode.attachChild(@mark)
            else
              # No hits? Then remove the red mark.
              rootNode.detachChild(@mark)
            end
          end
      end
    end
  end

  def makeCube name, x, y, z
    box = Box.new(1, 1, 1)
    cube = Geometry.new(name, box)
    cube.setLocalTranslation(x, y, z)
    mat1 = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
    mat1.setColor("Color", ColorRGBA::randomColor())
    cube.setMaterial(mat1)
    return cube
  end

  def makeFloor
    box = Box.new(15, 0.2, 15)
    floor = Geometry.new("the Floor", box)
    floor.setLocalTranslation(0, -4, -5)
    mat1 = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
    mat1.setColor("Color", ColorRGBA::Gray)
    floor.setMaterial(mat1)
    return floor
  end

  def initMark
    sphere = Sphere.new(30, 30, 0.2)
    @mark = Geometry.new("BOOM!", sphere)
    mark_mat = Material.new(assetManager, "Common/MatDefs/Misc/Unshaded.j3md")
    mark_mat.setColor("Color", ColorRGBA::Red)
    @mark.setMaterial(mark_mat)
  end

  def initCrossHairs
    setDisplayStatView(false)
    guiFont = assetManager.loadFont("Interface/Fonts/Default.fnt")
    ch = BitmapText.new(guiFont, false)
    ch.setSize(guiFont.getCharSet().getRenderedSize() * 2)
    ch.setText("+") # crosshairs
    ch.setLocalTranslation(self.settings.getWidth() / 2 - ch.getLineWidth()/2,
                           self.settings.getHeight() / 2 + ch.getLineHeight()/2, 0) #center
    guiNode.attachChild(ch)
  end

  def makeCharacter
    # load a character from jme3test-test-data
    golem = assetManager.loadModel("Models/Oto/Oto.mesh.xml")
    golem.scale(0.5)
    golem.setLocalTranslation(-1.0, -1.5, -0.6)

    #We must add a light to make the model visible
    sun = DirectionalLight.new()
    sun.setDirection(Vector3f.new(-0.1, -0.7, -1.0))
    golem.addLight(sun)
    return golem
  end

end

HelloPicker.new.start