require 'spec_helper'
require 'web_mock'
# Uncomment to use VCR
# require 'vcr_helper'

require "#{File.dirname(__FILE__)}/../app/bot_client"

def when_i_send_text(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                                                 "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def when_i_send_keyboard_updates(token, message_text, inline_selection)
  body = {
    "ok": true, "result": [{
      "update_id": 866_033_907,
      "callback_query": { "id": '608740940475689651', "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                          "message": {
                            "message_id": 626,
                            "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                            "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                            "date": 1_595_282_006,
                            "text": message_text,
                            "reply_markup": {
                              "inline_keyboard": [
                                [{ "text": 'Jon Snow', "callback_data": '1' }],
                                [{ "text": 'Daenerys Targaryen', "callback_data": '2' }],
                                [{ "text": 'Ned Stark', "callback_data": '3' }]
                              ]
                            }
                          },
                          "chat_instance": '2671782303129352872',
                          "data": inline_selection }
    }]
  }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def cuando_registro_cliente(nombre, direccion, codigo_postal, id_cliente)
  body = { "text": "Bienvenid@ #{nombre}" }

  stub_request(:any, 'http://web:3000/registrar')
    .with(
      body: { 'nombre' => nombre, 'direccion' => direccion, 'codigo_postal' => codigo_postal, 'id_cliente' => id_cliente }
    )
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def cuando_registro_cadete(nombre, vehiculo, id_cadete)
  body = { "text": "Bienvenid@ a la flota #{nombre}" }

  stub_request(:any, 'http://web:3000/registrar_cadete')
    .with(
      body: { 'nombre' => nombre, 'vehiculo' => vehiculo, 'id_cadete' => id_cadete }
    )
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def cuando_solicito_asignacion_de_envio(id_cadete)
  body = { "text": 'Te asignamos el siguiente envio con ID 1. Retirar el envio en Av Las Heras 1232, CP: 1425. Entregar el envio en Cerrito 628, CP: 1010' }

  stub_request(:put, 'http://web:3000/envios/asignar')
    .with(
      body: { 'id_cadete' => id_cadete }
    )
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def cuando_realizo_envio(tamanio, direccion, codigo_postal, id_cliente)
  body = { "text": 'Se registró tu envio con el ID: 8' }

  stub_request(:post, 'http://web:3000/envios')
    .with(
      body: { 'tamanio' => tamanio, 'direccion' => direccion, 'codigo_postal' => codigo_postal, 'id_cliente' => id_cliente }
    )
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def cuando_solicito_estado_de_envio_sin_asignar(id_envio)
  body = { "text": "Tu envio (ID: #{id_envio}) se encuentra pendiente de asignación" }

  stub_request(:get, "http://web:3000/envios/#{id_envio}")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def cuando_solicito_estado_de_envio_asignado(id_envio)
  body = { "text": "Tu envio (ID: #{id_envio}) se encuentra en proceso de entrega" }

  stub_request(:get, "http://web:3000/envios/#{id_envio}")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def cuando_confirmo_entrega_de_envio(id_envio)
  body = { "text": 'Gracias por entregar el envio!' }

  stub_request(:put, "http://web:3000/envios/#{id_envio}")
    .with(
      body: { 'estado' => 'entregado' }
    )
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def then_i_get_text(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def then_i_get_keyboard_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544',
              'reply_markup' => '{"inline_keyboard":[[{"text":"Jon Snow","callback_data":"1"},{"text":"Daenerys Targaryen","callback_data":"2"},{"text":"Ned Stark","callback_data":"3"}]]}',
              'text' => 'Quien se queda con el trono?' }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

describe 'BotClient' do
  it 'should get a /version message and respond with current version' do
    token = 'fake_token'

    when_i_send_text(token, '/version')
    then_i_get_text(token, Version.current)

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /say_hi message and respond with Hola Emilio' do
    token = 'fake_token'

    when_i_send_text(token, '/say_hi Emilio')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /start message and respond with Hola' do
    token = 'fake_token'

    when_i_send_text(token, '/start')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /stop message and respond with Chau' do
    token = 'fake_token'

    when_i_send_text(token, '/stop')
    then_i_get_text(token, 'Chau, egutter')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /tv message and respond with an inline keyboard' do
    token = 'fake_token'

    when_i_send_text(token, '/tv')
    then_i_get_keyboard_message(token, 'Quien se queda con el trono?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a "Quien se queda con el trono?" message and respond with' do
    token = 'fake_token'

    when_i_send_keyboard_updates(token, 'Quien se queda con el trono?', '2')
    then_i_get_text(token, 'A mi también me encantan los dragones!')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    token = 'fake_token'

    when_i_send_text(token, '/unknown')
    then_i_get_text(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'Deberia ver un mensaje de bienvenida al registrarse' do
    cuando_registro_cliente('Juan', 'Av Las Heras 1232', 'CP: 1425', 141_733_544)
    when_i_send_text('fake_token', '/registrar Juan, Av Las Heras 1232, CP: 1425')
    then_i_get_text('fake_token', 'Bienvenid@ Juan')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de error al intentar registrarse sin direccion' do
    cuando_registro_cliente('Juan', nil, 'CP: 1425', 141_733_544)
    when_i_send_text('fake_token', '/registrar Juan, , CP: 1425')
    then_i_get_text('fake_token', 'Verifique que se hayan ingresado todos los parametros (nombre, direccion, codigo postal)')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de error al intentar registrarse sin codigo postal' do
    cuando_registro_cliente('Juan', 'Av Las Heras 1232', nil, 141_733_544)
    when_i_send_text('fake_token', '/registrar Juan, Av Las Heras 1232, ')
    then_i_get_text('fake_token', 'Verifique que se hayan ingresado todos los parametros (nombre, direccion, codigo postal)')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de bienvenida al registrarse un nuevo cadete' do
    cuando_registro_cadete('Pedro', 'moto', 141_733_544)
    when_i_send_text('fake_token', '/registrar-cadete Pedro, moto')
    then_i_get_text('fake_token', 'Bienvenid@ a la flota Pedro')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de error al intentar registrarse un cadete sin nombre' do
    cuando_registro_cadete(nil, 'moto', 141_733_544)
    when_i_send_text('fake_token', '/registrar-cadete , moto')
    then_i_get_text('fake_token', 'Verifique que se hayan ingresado todos los parametros (nombre, vehiculo)')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de error al intentar registrarse un cadete sin vehiculo' do
    cuando_registro_cadete('Pedro', nil, 141_733_544)
    when_i_send_text('fake_token', '/registrar-cadete Pedro, ')
    then_i_get_text('fake_token', 'Verifique que se hayan ingresado todos los parametros (nombre, vehiculo)')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de creacion de envio exitosa al crear un nuevo envio' do
    cuando_realizo_envio('chico', 'Cerrito 628', 'CP:1010', 141_733_544)
    when_i_send_text('fake_token', '/nuevo-envio chico, Cerrito 628, CP:1010')
    then_i_get_text('fake_token', 'Se registró tu envio con el ID: 8')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de error intentar al crear un nuevo envio sin direccion' do
    cuando_realizo_envio('chico', nil, 'CP:1010', 141_733_544)
    when_i_send_text('fake_token', '/nuevo-envio chico, , CP:1010')
    then_i_get_text('fake_token', 'Verifique que se hayan ingresado todos los parametros (tamaño, direccion, codigo postal)')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de asignacion exitosa al solicitar asignacion' do
    cuando_solicito_asignacion_de_envio(141_733_544)
    when_i_send_text('fake_token', '/asignar-envio')
    then_i_get_text('fake_token', 'Te asignamos el siguiente envio con ID 1. Retirar el envio en Av Las Heras 1232, CP: 1425. Entregar el envio en Cerrito 628, CP: 1010')

    app = BotClient.new('fake_token')

    app.run_once
  end

  # rubocop:disable RSpec/ExampleLength
  it 'Deberia ver un mensaje de pendiente de asignacion del envio cuando no tiene un cadete asignado' do
    cuando_realizo_envio('chico', 'Cerrito 628', 'CP:1010', 141_733_544)
    cuando_solicito_estado_de_envio_sin_asignar(8)
    when_i_send_text('fake_token', '/estado-envio 8')
    then_i_get_text('fake_token', 'Tu envio (ID: 8) se encuentra pendiente de asignación')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de envio en proceso cuando el envio esta asignado' do
    cuando_realizo_envio('chico', 'Cerrito 628', 'CP:1010', 141_733_544)
    cuando_solicito_asignacion_de_envio(141_733_544)
    cuando_solicito_estado_de_envio_asignado(8)
    when_i_send_text('fake_token', '/estado-envio 8')
    then_i_get_text('fake_token', 'Tu envio (ID: 8) se encuentra en proceso de entrega')

    app = BotClient.new('fake_token')

    app.run_once
  end

  it 'Deberia ver un mensaje de entrega exitosa al confirmar una entrega' do
    cuando_realizo_envio('chico', 'Cerrito 628', 'CP:1010', 141_733_544)
    cuando_confirmo_entrega_de_envio(8)
    when_i_send_text('fake_token', '/confirmar-entrega 8')
    then_i_get_text('fake_token', 'Gracias por entregar el envio!')

    app = BotClient.new('fake_token')

    app.run_once
  end
  # rubocop:enable RSpec/ExampleLength
end
