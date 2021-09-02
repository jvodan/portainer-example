require 'yajl'
require 'ffi_yajl'
require 'excon'

def authenticate(user_creds)
  @auth_token = post('api/auth', user_creds)[:jwt]
end

def json_parser
  @json_parser ||= FFI_Yajl::Parser.new(symbolize_keys: true)
end

def connection(end_port)
  headers = {
    'content_type' => 'application/json'
  }

  headers['Authorization'] = "Bearer #{auth_token}" unless @auth_token.nil?

  @connection = Excon.new(@site,
                          debug_request: true,
                          debug_response: true,
                          ssl_verify_peer: false,
                          persistent: true,
                          headers: headers)
end

def get(uri, params=nil, time_out = 44)
  @retries = 0
  begin
  if params.nil?
        r = connection(uri).request(read_timeout: time_out,
                                         method: :get,
                                         path: uri)
      else
       r = connection(uri).request(read_timeout: time_out,
                                method: :get,
                                path: uri,
                                body: params.to_json) # ,:body => params.to_json)
      end
handle_response(r)
  rescue Excon::Error => e
    warn("Failed to open base url #{uri}\n#{e}")
    if @retries < 5
      @retries += 1
      retry
    end
    warn("Failed to open base url #{uri} after #{@retries} attempts")
  rescue StandardError => e
    warn("Uncaught E #{e.class.name} #{e}")
end
end

def post(uri, params, time_out = 44)
  @retries = 0
  begin
  if params.nil?
        r = connection(uri).request(read_timeout: time_out,
                                         method: :post,
                                         path: uri)
      else
       r = connection(uri).request(read_timeout: time_out,
                                method: :post,
                                path: uri,
                                body: params.to_json) # ,:body => params.to_json)
      end
 handle_response(r)
  rescue Excon::Error => e
    warn("Failed to open base url #{uri}\n#{e}")
    if @retries < 5
      @retries += 1
      retry
    end
    warn("Failed to open base url #{uri} after #{@retries} attempts")
  rescue StandardError => e
    warn("Uncaught E #{e.class.name} #{e}")
end
end

def delete(uri, params, time_out = 44)
  @retries = 0
  begin
  if params.nil?
        r = connection(uri).request(read_timeout: time_out,
                                         method: :delete,
                                         path: uri)
      else
       r = connection(uri).request(read_timeout: time_out,
                                method: :delete,
                                path: uri,
                                body: params.to_json) # ,:body => params.to_json)
      end
 handle_response(r)
  rescue Excon::Error => e
    warn("Failed to open base url #{uri}\n#{e}")
    if @retries < 5
      @retries += 1
      retry
    end
    warn("Failed to open base url #{uri} after #{@retries} attempts")
  rescue StandardError => e
    warn("Uncaught E #{e.class.name} #{e}")
end
end

def handle_response(r)
unless r.status == 304 || r.status == 204  #304 no change 204 no data 
warn r.status.to_s 
warn r.body.to_s
  if r.headers['Content-Type'].include?('application/json')
    json_parser.parse(r.body)
  else
    r.body
  end
end
end
