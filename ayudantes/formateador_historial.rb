class FormateadorHistorial
  attr_accessor :textos

  def initialize(respuesta)
    @textos = respuesta['texts']
  end
end
