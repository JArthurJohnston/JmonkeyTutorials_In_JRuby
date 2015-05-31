include Java
require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.material.Material,
            com.jme3.renderer.Camera,
            com.jme3.terrain.geomipmap.TerrainLodControl,
            com.jme3.terrain.heightmap.AbstractHeightMap,
            com.jme3.terrain.geomipmap.TerrainQuad,
            com.jme3.terrain.geomipmap.lodcalc.DistanceLodCalculator,
            com.jme3.terrain.heightmap.HillHeightMap, # for exercise 2
            com.jme3.terrain.heightmap.ImageBasedHeightMap,
            com.jme3.texture.Texture,
            com.jme3.texture.Texture::WrapMode

class HelloTerrain < SimpleApplication
  field_accessor :flyCam

  def simpleInitApp
    flyCam.setMoveSpeed(50)

    # 1. Create @terrain material and load four textures into it.
    @mat_terrain = Material.new(assetManager,"Common/MatDefs/Terrain/Terrain.j3md")

    #1.1) Add ALPHA map (for red-blue-green coded splat textures)
    @mat_terrain.setTexture("Alpha", assetManager.loadTexture("Textures/Terrain/splat/alphamap.png"))

    # 1.2) Add GRASS texture into the red layer (Tex1).
    grass = assetManager.loadTexture("Textures/Terrain/splat/grass.jpg")
    grass.setWrap(WrapMode::Repeat)
    @mat_terrain.setTexture("Tex1", grass)
    @mat_terrain.setFloat("Tex1Scale", 64)

    # 1.3) Add DIRT texture into the green layer (Tex2)
    dirt = assetManager.loadTexture("Textures/Terrain/splat/dirt.jpg")
    dirt.setWrap(WrapMode::Repeat)
    @mat_terrain.setTexture("Tex2", dirt)
    @mat_terrain.setFloat("Tex2Scale", 32)

    # 1.4) Add ROAD texture into the blue layer (Tex3)
    rock = assetManager.loadTexture("Textures/Terrain/splat/road.jpg")
    rock.setWrap(WrapMode::Repeat)
    @mat_terrain.setTexture("Tex3", rock)
    @mat_terrain.setFloat("Tex3Scale", 128)

    # 2. Create the height map */
    # heightmap = null why do they have to initialize this to null?
    heightMapImage = assetManager.loadTexture("Textures/Terrain/splat/mountains512.png")
    heightmap = ImageBasedHeightMap.new(heightMapImage.getImage())
    heightmap.load()

    #  3. We have prepared material and heightmap.
    # Now we create the actual @terrain:
    # 3.1) Create a TerrainQuad and name it "my @terrain".
    # 3.2) A good value for @terrain tiles is 64x64 -- so we supply 64+1=65.
    # 3.3) We prepared a heightmap of size 512x512 -- so we supply 512+1=513.
    # 3.4) As LOD step scale we supply Vector3f(1,1,1).
    # 3.5) We supply the prepared heightmap itself.

    patchSize = 65
    @terrain = TerrainQuad.new("my @terrain", patchSize, 513, heightmap.getHeightMap())

    # 4. We give the @terrain its material, position & scale it, and attach it.
    @terrain.setMaterial(@mat_terrain)
    @terrain.setLocalTranslation(0, -100, 0)
    @terrain.setLocalScale(2, 1, 2)
    rootNode.attachChild(@terrain)

    # 5. The LOD (level of detail) depends on were the camera is:
    control = TerrainLodControl.new(@terrain, getCamera())
    @terrain.addControl(control)
  end
end

HelloTerrain.new.start
