require 'faraday'
require_relative '../excepciones/conexion_api_error'
require_relative '../validadores/validador_entrada'

class ValidadorEntrada
  def validar_cliente(nombre, direccion, codigo_postal)
    nombre.nil? || nombre.empty? || direccion.nil? || direccion.empty? || codigo_postal.nil? || codigo_postal.empty?
  end
end
