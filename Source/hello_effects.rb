include Java
require_relative '../lib/jMonkeyEngine3.jar'

java_import com.jme3.app.SimpleApplication,
            com.jme3.effect.ParticleEmitter,
            com.jme3.effect.ParticleMesh,
            com.jme3.material.Material,
            com.jme3.math.ColorRGBA,
            com.jme3.math.Vector3f

class HelloEffects < SimpleApplication

  #override
  def simpleInitApp
    fire = ParticleEmitter.new("Emitter", ParticleMesh::Type::Triangle, 30)
    mat_red = Material.new(assetManager, "Common/MatDefs/Misc/Particle.j3md")
    mat_red.setTexture("Texture", assetManager.loadTexture("Effects/Explosion/flame.png"))
    fire.setMaterial(mat_red)
    fire.setImagesX(2)
    fire.setImagesY(2) # 2x2 texture animation
    fire.setEndColor(ColorRGBA.new(1, 0, 0, 1))   # red
    fire.setStartColor(ColorRGBA.new(1, 1, 0, 0.5)) # yellow
    fire.getParticleInfluencer().setInitialVelocity(Vector3f.new(0, 2, 0))
    fire.setStartSize(1.5)
    fire.setEndSize(0.1)
    fire.setGravity(0, 0, 0)
    fire.setLowLife(1)
    fire.setHighLife(3)
    fire.getParticleInfluencer().setVelocityVariation(0.3)
    rootNode.attachChild(fire)

    debris = ParticleEmitter.new("Debris", ParticleMesh::Type::Triangle, 10)
    debris_mat = Material.new(assetManager, "Common/MatDefs/Misc/Particle.j3md")
    debris_mat.setTexture("Texture", assetManager.loadTexture("Effects/Explosion/Debris.png"))
    debris.setMaterial(debris_mat)
    debris.setImagesX(3)
    debris.setImagesY(3) # 3x3 texture animation
    debris.setRotateSpeed(4)
    debris.setSelectRandomImage(true)
    debris.getParticleInfluencer().setInitialVelocity(Vector3f.new(0, 4, 0))
    debris.setStartColor(ColorRGBA::White)
    debris.setGravity(0, 6, 0)
    debris.getParticleInfluencer().setVelocityVariation(0.60)
    rootNode.attachChild(debris)
    debris.emitAllParticles()
  end
end

HelloEffects.new.start