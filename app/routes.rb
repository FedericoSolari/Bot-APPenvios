require "#{File.dirname(__FILE__)}/../lib/routing"
require "#{File.dirname(__FILE__)}/../lib/version"
require "#{File.dirname(__FILE__)}/tv/series"
require_relative '../conectores/conector_api'
require_relative '../excepciones/parametros_invalidos_error'
require_relative '../excepciones/conexion_api_error'

class Routes
  include Routing

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{message.from.first_name}", parse_mode: 'MarkdownV2')
  end

  on_message_pattern %r{/say_hi (?<name>.*)} do |bot, message, args|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{args['name']}", parse_mode: 'MarkdownV2')
  end

  on_message_pattern %r{/registrar (?<nombre>.*), (?<direccion>.*), (?<codigo_postal>.*)} do |bot, message, args|
    conector_api = ConectorApi.new
    respuesta = conector_api.registrar_cliente(args['nombre'], args['direccion'], args['codigo_postal'], message.chat.id)
    bot.api.send_message(chat_id: message.chat.id, text: respuesta['text'].gsub(/[-.()!]/, '\\\\\0'), parse_mode: 'MarkdownV2')
  rescue ConexionApiError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  rescue ParametrosInvalidosError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  end

  on_message_pattern %r{/registrar-cadete (?<nombre>.*), (?<vehiculo>.*)} do |bot, message, args|
    conector_api = ConectorApi.new
    texto = conector_api.registrar_cadete(args['nombre'], args['vehiculo'], message.chat.id)
    bot.api.send_message(chat_id: message.chat.id, text: texto['text'].gsub(/[-.()!]/, '\\\\\0'), parse_mode: 'MarkdownV2')
  rescue ConexionApiError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  rescue ParametrosInvalidosError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  end

  on_message_pattern %r{/nuevo-envio (?<tamanio>.*), (?<direccion>.*), (?<codigo_postal>.*)} do |bot, message, args|
    conector_api = ConectorApi.new
    texto = conector_api.realizar_envio(args['tamanio'], args['direccion'], args['codigo_postal'], message.chat.id)
    bot.api.send_message(chat_id: message.chat.id, text: texto['text'].gsub(/[-.()!]/, '\\\\\0'), parse_mode: 'MarkdownV2')
  rescue ConexionApiError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  rescue ParametrosInvalidosError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  end

  on_message_pattern %r{/estado-envio (?<id_envio>.*)} do |bot, message, args|
    conector_api = ConectorApi.new
    texto = conector_api.estado_envio(args['id_envio'].to_i)
    bot.api.send_message(chat_id: message.chat.id, text: texto['text'].gsub(/[-.()!]/, '\\\\\0'), parse_mode: 'MarkdownV2')
  rescue ConexionApiError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  rescue ParametrosInvalidosError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  end

  on_message '/asignar-envio' do |bot, message|
    conector_api = ConectorApi.new
    texto = conector_api.asignar_envio(message.chat.id)
    bot.api.send_message(chat_id: message.chat.id, text: texto['text'].gsub(/[-.()!]/, '\\\\\0'), parse_mode: 'MarkdownV2')
  rescue ConexionApiError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  end

  on_message_pattern %r{/confirmar-entrega (?<id_envio>.*)} do |bot, message, args|
    conector_api = ConectorApi.new
    respuesta = conector_api.confirmar_entrega(args['id_envio'].to_i)
    cliente = respuesta['cliente']
    bot.api.send_message(chat_id: message.chat.id, text: respuesta['text'].gsub(/[-.()!]/, '\\\\\0'), parse_mode: 'MarkdownV2')
    # envio mensaje al cliente
    bot.api.send_message(chat_id: cliente, text: respuesta['text_to_client'].gsub(/[-.()!]/, '\\\\\0'), parse_mode: 'MarkdownV2')
  rescue ConexionApiError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  rescue ParametrosInvalidosError => e
    bot.api.send_message(chat_id: message.chat.id, text: e.message, parse_mode: 'MarkdownV2')
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.username}", parse_mode: 'MarkdownV2')
  end

  on_message '/time' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "La hora es, #{Time.now}", parse_mode: 'MarkdownV2')
  end

  on_message '/tv' do |bot, message|
    kb = [Tv::Series.all.map do |tv_serie|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: tv_serie.name, callback_data: tv_serie.id.to_s)
    end]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

    bot.api.send_message(chat_id: message.chat.id, text: 'Quien se queda con el trono?', reply_markup: markup, parse_mode: 'MarkdownV2')
  end

  on_message '/busqueda_centro' do |bot, message|
    kb = [
      Telegram::Bot::Types::KeyboardButton.new(text: 'Compartime tu ubicacion', request_location: true)
    ]
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
    bot.api.send_message(chat_id: message.chat.id, text: 'Busqueda por ubicacion', reply_markup: markup, parse_mode: 'MarkdownV2')
  end

  on_location_response do |bot, message|
    response = "Ubicacion es Lat:#{message.location.latitude} - Long:#{message.location.longitude}"
    puts response
    bot.api.send_message(chat_id: message.chat.id, text: response, parse_mode: 'MarkdownV2')
  end

  on_response_to 'Quien se queda con el trono?' do |bot, message|
    response = Tv::Series.handle_response message.data
    bot.api.send_message(chat_id: message.message.chat.id, text: response, parse_mode: 'MarkdownV2')
  end

  on_message '/version' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: Version.current, parse_mode: 'MarkdownV2')
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo\\! Me repetis la pregunta?', parse_mode: 'MarkdownV2')
  end
end
