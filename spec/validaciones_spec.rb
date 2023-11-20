# La realidad es que nos dimos cuenta de la posibilidad de agregar estos tests luego
# de realizar los refactors, sabemos que no va alineado a lo enseñado en la materia.

describe 'Validaciones' do
  describe 'cliente' do
    it 'Debería devolver false al mandar Juan, Av. Cerrito 630, CP: 1245' do
      respuesta = ValidadorEntrada.new.validar_cliente('Juan', 'Av. Cerrito 630', 'CP: 1245')
      expect(respuesta).to eq false
    end

    it 'Debería devolver true al mandar Juan, Av. Cerrito 630' do
      respuesta = ValidadorEntrada.new.validar_cliente('Juan', 'Av. Cerrito 630', nil)
      expect(respuesta).to eq true
    end

    it 'Debería devolver true al mandar Juan, CP: 1245' do
      respuesta = ValidadorEntrada.new.validar_cliente('Juan', nil, 'CP: 1245')
      expect(respuesta).to eq true
    end

    it 'Debería devolver true al mandar Av. Cerrito 630, CP: 1245' do
      respuesta = ValidadorEntrada.new.validar_cliente(nil, 'Av. Cerrito 630', 'CP: 1245')
      expect(respuesta).to eq true
    end
  end

  describe 'cadete' do
    it 'Debería devolver false al mandar Juan, Moto' do
      respuesta = ValidadorEntrada.new.validar_cadete('Juan', 'Moto')
      expect(respuesta).to eq false
    end

    it 'Debería devolver true al mandar Juan' do
      respuesta = ValidadorEntrada.new.validar_cadete('Juan', nil)
      expect(respuesta).to eq true
    end

    it 'Debería devolver true al mandar Moto' do
      respuesta = ValidadorEntrada.new.validar_cadete(nil, 'Moto')
      expect(respuesta).to eq true
    end
  end
end
