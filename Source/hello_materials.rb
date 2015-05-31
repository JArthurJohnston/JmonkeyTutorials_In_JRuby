include Java

require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.material.Material,
            com.jme3.scene.Geometry,
            com.jme3.scene.shape.Box,
            com.jme3.scene.shape.Sphere,
            com.jme3.math.Vector3f,
            com.jme3.math.ColorRGBA,
            com.jme3.light.DirectionalLight,
            com.jme3.renderer.queue.RenderQueue::Bucket,
            com.jme3.texture.Texture,
            com.jme3.util.TangentBinormalGenerator,
            com.jme3.material.RenderState::BlendMode

class HelloMaterials < SimpleApplication

  def simpleInitApp
    # A simple textured cube -- in good MIP map quality.
    cube1Mesh = Box.new( 1, 1, 1)
    cube1Geo = Geometry.new('My Textured Box', cube1Mesh)
    cube1Geo.setLocalTranslation(Vector3f.new(-3,1.1,0))
    cube1Mat = Material.new(assetManager, 'Common/MatDefs/Misc/Unshaded.j3md')
    cube1Texture = assetManager.loadTexture('Interface/Logo/Monkey.jpg')
    cube1Mat.setTexture('ColorMap', cube1Texture)
    cube1Geo.setMaterial(cube1Mat)
    rootNode.attachChild(cube1Geo)

    # A translucent/transparent texture, similar to a window frame. */
    cube2Mesh = Box.new( 1,1,0.01)
    cube2Geo = Geometry.new('window frame', cube2Mesh)
    cube2Mat = Material.new(assetManager, 'Common/MatDefs/Misc/Unshaded.j3md')
    cube2Mat.setTexture('ColorMap', assetManager.loadTexture('Textures/ColoredTex/Monkey.png'))
    cube2Mat.getAdditionalRenderState().setBlendMode(BlendMode::Alpha)
    cube2Geo.setQueueBucket(Bucket::Transparent)
    cube2Geo.setMaterial(cube2Mat)
    rootNode.attachChild(cube2Geo)

     # A bumpy rock with a shiny light effect.*/
    sphereMesh = Sphere.new(32,32, 2)
    sphereGeo = Geometry.new('Shiny rock', sphereMesh)
    sphereMesh.setTextureMode(Sphere::TextureMode::Projected) # better quality on spheres
    TangentBinormalGenerator.generate(sphereMesh)             # for lighting effect
    sphereMat = Material.new(assetManager, 'Common/MatDefs/Light/Lighting.j3md')
    sphereMat.setTexture('DiffuseMap',assetManager.loadTexture('Textures/Terrain/Pond/Pond.jpg'))
    sphereMat.setTexture('NormalMap',
    assetManager.loadTexture('Textures/Terrain/Pond/Pond_normal.png'))
    sphereMat.setBoolean('UseMaterialColors', true)
    sphereMat.setColor('Diffuse', ColorRGBA::White)
    sphereMat.setColor('Specular',ColorRGBA::White)
    sphereMat.setFloat('Shininess', 64)  # [0,128]
    sphereGeo.setMaterial(sphereMat)
    sphereGeo.setLocalTranslation(0,2,-2) # Move it a bit
    sphereGeo.rotate(1.6, 0, 0)         # Rotate it a bit
    rootNode.attachChild(sphereGeo)

    # Must add a light to make the lit object visible! */
    sun = DirectionalLight.new()
    sun.setDirection(Vector3f.new(1,0,-2).normalizeLocal())
    sun.setColor(ColorRGBA::White)
    rootNode.addLight(sun)
  end
end

HelloMaterials.new.start
