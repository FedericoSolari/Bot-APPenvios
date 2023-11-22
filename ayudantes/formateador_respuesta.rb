class FormateadorRespuesta
  attr_accessor :texto, :cliente_id, :texto_cliente

  def initialize(respuesta)
    @texto = respuesta['text'].gsub(/[-.()!]/, '\\\\\0')
    @cliente_id = respuesta['cliente']
    @texto_cliente = respuesta['text_to_client']&.gsub(/[-.()!]/, '\\\\\0')
  end
end
