require "sbif_chile/version"
require 'httparty'
require 'dotenv/load'

class SbifChile
  include HTTParty

  attr_reader :date_current

  base_uri 'http://api.sbif.cl/api-sbifv3/recursos_api/'

  def initialize(token = '')
    @api_key = ENV['SBIF_API_KEY'] || token
    @date_current = {
      date: '2017-02-26 14:33:13 -0300',
      dolar: 0.0,
      euro: 0.0,
      ipc: 0.0,
      tad: 0.0,
      tmc: [
        {
          date: '2017-02-26 14:33:13 -0300',
          title: 'no title',
          subtitle: 'no subtitle',
          value: 0.0,
          type: 0,
        }
      ],
      uf: 0.0,
      utm: 0.0,
    }
  end

  def indicators_current
    dolar = current_date('dolar')
    euro = current_date('euro')
    ipc = current_date('ipc')
    tab = current_date('tab')
    tmc = current_date('tmc')
    uf = current_date
    utm = current_date('utm')
    @date_current[:date] = Time.now
    @date_current[:dolar] = dolar[0][:value] unless dolar.nil?
    @date_current[:euro] = euro[0][:value] unless euro.nil?
    @date_current[:ipc] = ipc[0][:value] unless ipc.nil?
    @date_current[:tad] = tab[0][:value] unless tab.nil?
    @date_current[:tmc] = tmc unless tmc.nil?
    @date_current[:uf] = uf[0][:value] unless uf.nil?
    @date_current[:utm] = utm[0][:value] unless utm.nil?
  end

  def current_date(resource = 'uf')
    response = self.class.get("/#{resource.downcase}?apikey=#{@api_key}&formato=json")
    if response.code.equal?(200)
      process_data(resource, response)
    elsif response.code >= 400
      raise "Bad Request for #{resource.downcase} : http_code: #{response.code} - http_message: #{response.message} - http_description: #{response['Mensaje']}"
    end
  rescue Exception => ex
    puts "ERROR - #{ex.message}"
  end

  def date_range(resource = 'uf' ,first_date = Time.now, second_date = Time.now)
    if first_date <= second_date
      response = self.class.get("/#{resource.downcase}/periodo/#{first_date.year}/#{first_date.month}/#{second_date.year}/#{second_date.month}?apikey=#{@api_key}&formato=json")
      if response.code.equal?(200)
        process_data(resource, response)
      elsif response.code >= 400
        raise "Bad Request for #{resource.downcase} : http_code: #{response.code} - http_message: #{response.message} - http_description: #{response['Mensaje']}"
      end
    else
      raise 'First date can\'t be greater than second'
    end
  rescue Exception => ex
    puts "ERROR - #{ex.message}"
  end

  private

  def process_data(resource = 'uf', source_data)
    data = response(resource, source_data)
    response = data(resource, data)
  end

  def data(resource = 'tmc', response)
    case resource
    when 'tmc' then
      data = Hash[response.map { |x| [date: x[:fecha], title: x[:titulo], subtitle: x[:subtitulo], value: to_float(x[:valor]), type: x[:tipo]] }]
    else
      data = Hash[response.map { |x| [date: x[:fecha], value: to_float(x[:valor])] }]
    end
    data.map{ |x| x[0] }
  end

  def response(resource = 'uf', response)
    response = case resource
                when 'dolar' then symbolize_keys_deep!(response)[:dolares]
                when 'euro' then symbolize_keys_deep!(response)[:euros]
                when 'ipc' then symbolize_keys_deep!(response)[:ipcs]
                when 'tab' then symbolize_keys_deep!(response)[:tabs]
                when 'tmc' then symbolize_keys_deep!(response)[:tmcs]
                when 'uf' then symbolize_keys_deep!(response)[:ufs]
                when 'utm' then symbolize_keys_deep!(response)[:utms]
                end
  end

  def symbolize_keys_deep!(hash)
    sub_hash = {}
    hash.each do |k,x|
       keys = k.downcase.to_sym
       sub_hash[keys] = Array.new
       x.each do |z|
         new_hash = {}
         z.each do |v,w|
           new_hash[v.downcase.to_sym] = w
         end
         sub_hash[keys] << new_hash
       end
    end
    sub_hash
  end

  def to_float(string)
    string.gsub('.','').gsub(',','.').to_f
  end

end
