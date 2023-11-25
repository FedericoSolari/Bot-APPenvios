class Version
  MAYOR = 7
  MINOR = 0
  PATCH = 0

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
