require 'faraday'
require_relative '../excepciones/conexion_api_error'
require_relative '../excepciones/parametros_invalidos_error'
require_relative '../validadores/validador_entrada'

class ConectorApi
  def initialize
    @api_url = ENV['API_URL'] || 'http://web:3000'
    @validador = ValidadorEntrada.new
  end

  def registrar_cliente(nombre, direccion, codigo_postal, id_cliente)
    parametros_invalidos = @validador.validar_cliente(nombre, direccion, codigo_postal)
    raise ParametrosInvalidosError, 'Verifique que se hayan ingresado todos los parametros (nombre, direccion, codigo postal)' if parametros_invalidos

    begin
      cuerpo_solicitud = { nombre:, direccion:, codigo_postal:, id_cliente: }.to_json
      respuesta_http = Faraday.post("#{@api_url}/registrar", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      parseador_respuesta(respuesta_http)
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def registrar_cadete(nombre, vehiculo, id_cadete)
    parametros_invalidos = @validador.validar_cadete(nombre, vehiculo)
    raise ParametrosInvalidosError, 'Verifique que se hayan ingresado todos los parametros (nombre, vehiculo)' if parametros_invalidos

    begin
      cuerpo_solicitud = { nombre:, vehiculo:, id_cadete: }.to_json
      respuesta_http = Faraday.post("#{@api_url}/registrar_cadete", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      parseador_respuesta(respuesta_http)
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def realizar_envio(direccion, codigo_postal, id_cliente)
    cuerpo_solicitud = { direccion:, codigo_postal:, id_cliente: }.to_json
    begin
      respuesta_http = Faraday.post("#{@api_url}/envios", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      parseador_respuesta(respuesta_http)
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def asignar_envio(id_cadete)
    cuerpo_solicitud = { id_cadete: }.to_json
    begin
      respuesta_http = Faraday.put("#{@api_url}/envios/asignar", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      parseador_respuesta(respuesta_http)
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def estado_envio(id_envio)
    respuesta_http = Faraday.get("#{@api_url}/envios/#{id_envio}")
    parseador_respuesta(respuesta_http)
  rescue Faraday::Error
    raise ConexionApiError
  end

  def confirmar_envio(id_envio)
    cuerpo_solicitud = { estado: 'entregado' }.to_json
    begin
      respuesta_http = Faraday.put("#{@api_url}/envios/#{id_envio}", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
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
