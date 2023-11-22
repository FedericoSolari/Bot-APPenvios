class FormateadorRespuesta
  def initialize(respuesta)
    @texto = respuesta['text']
    @cliente = respuesta['cliente']
    @texto_cliente = respuesta['text_to_client']
  end

  def obtener_texto
    @texto
  end
end
