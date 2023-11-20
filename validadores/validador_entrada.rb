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

  def validar_envio(direccion, codigo_postal)
    direccion.nil? || direccion.empty? || codigo_postal.nil? || codigo_postal.empty?
  end

  def validar_id_envio(id_envio)
    id_envio.nil? || id_envio.negative?
  end
end
