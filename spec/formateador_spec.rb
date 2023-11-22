require_relative '../ayudantes/formateador_respuesta'

describe 'Formateador de respuesta' do
  it 'Debería devolver el texto correcto' do
    respuesta = { 'text' => 'texto a devolver' }
    formateador = FormateadorRespuesta.new(respuesta)
    respuesta_obtenida = formateador.obtener_texto
    expect(respuesta_obtenida).to eq respuesta['text']
  end
end
