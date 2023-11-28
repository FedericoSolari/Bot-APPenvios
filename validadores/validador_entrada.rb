require 'faraday'
require_relative '../excepciones/conexion_api_error'
require_relative '../validadores/validador_entrada'

class ValidadorEntrada
  def validar_cliente(nombre, direccion, codigo_postal)
    nombre.nil? || nombre.empty? || direccion.nil? || direccion.empty? || codigo_postal.nil? || codigo_postal.empty?
  end

  def validar_cadete(nombre, vehiculo)
    # agregar validacion de vehiculo (bicicleta, auto, moto)
    nombre.nil? || nombre.empty? || vehiculo.nil? || vehiculo.empty?
  end

  def no_hay_direccion_o_codigo_postal(direccion, codigo_postal)
    direccion.nil? || direccion.empty? || codigo_postal.nil? || codigo_postal.empty?
  end

  def no_hay_tipo_o_tamanio(tipo, tamanio)
    tipo.nil? || tipo.empty? || tamanio.nil? || tamanio.empty?
  end

  def validar_envio(tipo, tamanio, direccion, codigo_postal)
    no_hay_direccion_o_codigo_postal(direccion, codigo_postal) || no_hay_tipo_o_tamanio(tipo, tamanio)
  end

  def validar_tamanio(tamanio)
    !%w[chico mediano grande].include?(tamanio.downcase)
  end

  def validar_id_envio(id_envio)
    id_envio.nil? || id_envio.negative?
  end

  def validar_tipo_de_envio(tipo)
    !%w[clasico express].include?(tipo.downcase)
  end
end
