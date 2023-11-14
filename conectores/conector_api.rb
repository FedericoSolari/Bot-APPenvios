require 'faraday'
require_relative '../excepciones/conexion_api_error'

RUTA_API_TEST = 'http://web:3000'.freeze

class ConectorApi
  def initialize
    @api_url = case ENV['ENTORNO']
               when 'entorno-test'
                RUTA_API_TEST
               else
                RUTA_API_TEST
               end
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
