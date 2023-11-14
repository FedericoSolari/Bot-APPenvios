require 'faraday'
require_relative '../excepciones/conexion_api_error'

RUTA_API_TEST = 'http://web:3000'.freeze
RUTA_API = 'http://restapi:8080'.freeze # Ver el archivo "service.yaml" de la api

class ConectorApi
  def initialize
    @api_url = case ENV['ENV']
               when 'test'
                 RUTA_API_TEST
               when 'development'
                 RUTA_API_TEST
               else
                 RUTA_API
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
