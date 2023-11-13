require 'faraday'
require_relative '../excepciones/conexion_api_error'

class ConectorApi
  def initialize(api_url)
    @api_url = api_url
  end

  def registrar_cliente(nombre, direccion, codigo_postal)
    cuerpo_solicitud = { nombre:, direccion:, codigo_postal: }.to_json
    begin
      respuesta_http = Faraday.post("#{@api_url}/registrar", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      parseador_respuesta(respuesta_http)
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  private

  def parseador_respuesta(respuesta_http)
    JSON.parse(respuesta_http.body)
  end
end
