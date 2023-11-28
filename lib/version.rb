class Version
  MAYOR = 7
  MINOR = 2
  PATCH = 0

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
