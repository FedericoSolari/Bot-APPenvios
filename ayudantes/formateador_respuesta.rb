class FormateadorRespuesta
  attr_accessor :texto, :cliente_id, :texto_cliente

  def initialize(respuesta)
    @texto = respuesta['text']
    @cliente_id = respuesta['cliente']
    @texto_cliente = respuesta['text_to_client']
  end
end
