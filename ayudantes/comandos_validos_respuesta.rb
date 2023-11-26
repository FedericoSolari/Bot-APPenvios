class AyudanteComandosDisponibles
  def obtener_comandos_validos
    'El comando ingresado no existe' \
            "\n"\
            'Los comandos válidos son:' \
            "\n"\
            '* Registrar cliente:* /registrar\\-nombre, direccion, codigo\\_postal' \
            "\n"\
            '* Registrar cadete:* /registrar\\-cadete nombre, vehiculo' \
            "\n"\
            '* Nuevo envío:* /nuevo\-envio tamaño, direccion, codigo\\_postal' \
            "\n"\
            '* Consultar estado de envío:* /estado\\-envio id\\_del\\_envio' \
            "\n"\
            '* Asignar cadete a envío:* /asignar\\-envio' \
            "\n"\
            '* Confirmar retiro de envio:* /confirmar\\-retiro id\\_del\\_envio' \
            "\n"\
            '* Confirmar entrega de envío:* /confirmar\\-entrega id\\_del\\_envio'
  end
end
