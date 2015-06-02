class MaterialUtils

  class << self
    def makeMaterial assetManager, nameString, colorRGBA
      mat = Material.new(assetManager, nameString)
      mat.setColor("Color", colorRGBA)
      return mat
    end
  end

end