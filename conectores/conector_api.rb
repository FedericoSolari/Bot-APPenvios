require 'faraday'
require_relative '../excepciones/conexion_api_error'
require_relative '../excepciones/parametros_invalidos_error'
require_relative '../excepciones/solicitud_no_exitosa_error'
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
      respuesta_http = Faraday.post("#{@api_url}/clientes", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
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
      respuesta_http = Faraday.post("#{@api_url}/cadetes", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      parseador_respuesta(respuesta_http)
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def realizar_envio(tipo, tamanio, direccion, codigo_postal, id_cliente)
    parametros_invalidos = @validador.validar_envio(tipo, tamanio, direccion, codigo_postal)
    raise ParametrosInvalidosError, 'Verifique que se hayan ingresado todos los parametros (tamaño, direccion, codigo postal)' if parametros_invalidos

    tamanio_invalido = @validador.validar_tamanio(tamanio)
    raise ParametrosInvalidosError, 'Tamaño indicado incorrecto, los tamaños validos son: Chico, Mediano o Grande' if tamanio_invalido

    tamanio_invalido = @validador.validar_tipo_de_envio(tipo)
    raise ParametrosInvalidosError, 'Tipo de envio indicado incorrecto, los tipos de envios validos son: Clasico y Express' if tamanio_invalido

    begin
      cuerpo_solicitud = { tipo:, tamanio:, direccion:, codigo_postal:, id_cliente: }.to_json
      respuesta_http = Faraday.post("#{@api_url}/envios", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      parseador_respuesta(respuesta_http)
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def asignar_envio(id_cadete)
    cuerpo_solicitud = { id_cadete: }.to_json
    respuesta_http = Faraday.put("#{@api_url}/envios/asignar", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
    parseador_respuesta(respuesta_http)
  rescue Faraday::Error
    raise ConexionApiError
  end

  def estado_envio(id_envio, id_cliente)
    parametros_invalidos = @validador.validar_id_envio(id_envio)
    raise ParametrosInvalidosError, 'Verifique que se haya ingresado el id de envio' if parametros_invalidos

    begin
      cuerpo_solicitud = { id_cliente: }.to_json
      respuesta_http = Faraday.post("#{@api_url}/envios/#{id_envio}", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      parseador_respuesta(respuesta_http)
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def confirmar_entrega(id_envio)
    parametros_invalidos = @validador.validar_id_envio(id_envio)
    raise ParametrosInvalidosError, 'Verifique que se haya ingresado el id de envio' if parametros_invalidos

    begin
      cuerpo_solicitud = { estado: 'entregado' }.to_json
      respuesta_http = Faraday.put("#{@api_url}/envios/#{id_envio}", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      respuesta_parseada = parseador_respuesta(respuesta_http)
      raise SolicitudNoExitosaError, respuesta_parseada['text'].gsub(/\./, '\.') unless solicitud_exitosa(respuesta_http)

      respuesta_parseada
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def confirmar_retiro(id_envio)
    parametros_invalidos = @validador.validar_id_envio(id_envio)
    raise ParametrosInvalidosError, 'Verifique que se haya ingresado el id de envio' if parametros_invalidos

    begin
      cuerpo_solicitud = { estado: 'en camino' }.to_json
      respuesta_http = Faraday.put("#{@api_url}/envios/#{id_envio}", cuerpo_solicitud, { 'Content-Type' => 'application/json' })
      respuesta_parseada = parseador_respuesta(respuesta_http)
      raise SolicitudNoExitosaError, respuesta_parseada['text'].gsub(/\./, '\.') unless solicitud_exitosa(respuesta_http)

      respuesta_parseada
    rescue Faraday::Error
      raise ConexionApiError
    end
  end

  def consultar_historial(id_cliente)
    respuesta_http = Faraday.get("#{@api_url}/clientes/#{id_cliente}")
    respuesta_parseada = parseador_respuesta(respuesta_http)
    raise SolicitudNoExitosaError, respuesta_parseada['text'].gsub(/\./, '\.') unless solicitud_exitosa(respuesta_http)

    respuesta_parseada
  rescue Faraday::Error
    raise ConexionApiError
  end

  private

  def parseador_respuesta(respuesta_http)
    JSON.parse(respuesta_http.body)
  end

  def solicitud_exitosa(respuesta)
    respuesta.status >= 200 && respuesta.status < 300
  end
end
