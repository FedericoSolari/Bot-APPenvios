class Version
  MAYOR = 3
  MINOR = 4
  PATCH = 1

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
