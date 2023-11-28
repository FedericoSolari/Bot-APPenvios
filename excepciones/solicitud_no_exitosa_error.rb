class SolicitudNoExitosaError < StandardError
  def initialize(message = 'La solicitud no ha sido exitosa')
    super(message)
  end
end
