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

  def simpleInitApp
    raise 'not done yet'
  end
end

HelloCollision.new.start