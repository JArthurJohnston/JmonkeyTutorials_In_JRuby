include Java

class SpatialUtils

  class << self
    # noinspection RubyArgCount
    def makeNode aName
      return Node.new(aName)
    end

    def makeGeometry(mesh, material, name)
      geometry_new = Geometry.new(mesh, name)
      geometry_new.setMaterial(material)
      return geometry_new
    end

    def makeGeometry(location, scale, mesh, material, name)
      geometry = self.makeGeometry(name, mesh)
      geometry.setLocalTranslation(location)
      geometry.setLocalScale(scale)
      return geometry
    end
    #overloaded methods this NEEDS refactoring
  end

end