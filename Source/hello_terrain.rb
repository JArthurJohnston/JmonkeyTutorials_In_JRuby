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
            com.jme3.texture.Texture.WrapMode
#  java.util.ArrayList,
#  java.util.List,
# i might not need these, I could probably just use ruby arrays

class HelloTerrain < SimpleApplication

end
