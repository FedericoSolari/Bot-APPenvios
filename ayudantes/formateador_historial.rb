require 'active_model'
require_relative '../excepciones/respuesta_historial_error'

class FormateadorHistorial
  include ActiveModel::Validations

  attr_accessor :textos

  validate :validar_textos

  def initialize(respuesta)
    @textos = respuesta['texts']
    validate!
  end

  def validar_textos
    raise RespuestaHistorialError if @textos.nil?
  end
end
