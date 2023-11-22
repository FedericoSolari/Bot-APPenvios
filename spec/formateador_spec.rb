require_relative '../ayudantes/formateador_respuesta'

describe 'Formateador de respuesta' do
  it 'Debería devolver el texto correcto' do
    respuesta = { 'text' => 'texto a devolver' }
    formateador = FormateadorRespuesta.new(respuesta)
    expect(formateador.texto).to eq respuesta['text']
  end

  it 'Debería devolver el id del cliente ' do
    respuesta = { 'text' => 'texto a devolver', 'cliente' => 56_131, 'text_to_client' => 'texto para el cliente' }
    formateador = FormateadorRespuesta.new(respuesta)
    expect(formateador.cliente_id).to eq respuesta['cliente']
  end

  it 'Debería devolver el texto correcto para enviar al cliente' do
    respuesta = { 'text' => 'texto a devolver', 'cliente' => 56_131, 'text_to_client' => 'texto para el cliente' }
    formateador = FormateadorRespuesta.new(respuesta)
    expect(formateador.texto_cliente).to eq respuesta['text_to_client']
  end
end
