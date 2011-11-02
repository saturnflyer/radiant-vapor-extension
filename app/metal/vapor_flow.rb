require 'cgi'

class VaporFlow
  include Vaporizer
  
  # Radiant must be restarted if the configuration changes for this setting
  @@use_regexp = nil
  class << self  
    def call(env)
      url = env["PATH_INFO"]

      if url.blank?
        return send_to_radiant
      end

      url = url.sub(/^\//,'') unless url == '/' #clean off the first slash, like it is stored in the db

      db_escaped_key = ActiveRecord::Base.connection.adapter_name =~ /mysql/i ? '`key`' : 'key'
      sql = "SELECT * FROM config where #{db_escaped_key} = 'vapor.use_regexp'"
      if @@use_regexp.nil?
        config_key = Radiant::Config.connection.select_one(sql)
        @@use_regexp = (config_key && config_key['value'] == 'true') ? true : false
      end
      if @@use_regexp
        catch_with_regexp(url)
      else
        catch_without_regexp(url)
      end
    end
   
    def catch_with_regexp(url)
      result = self.send_to_radiant
      FlowMeter.all.sort.reverse.each do |meter|
        key = meter[0]
        value = meter[1]
        if (match = url.match(Regexp.new('^'+key)))
          status = value[1].to_i
          redirect_url = self.match_substitute(value[0], match)
          result = [status, {"Location" => CGI.unescape(local_or_external_path(redirect_url))}, [status.to_s]]
          return result
          break
        end
      end
      return result
    end
    
    def catch_without_regexp(url)
      url = url.sub(/\/$/, '') unless url == '/' # drop the trailing slash for lookup
      a_match = FlowMeter.all[url]
      unless a_match.nil?
        status = a_match[1].to_i
        redirect_url = a_match[0]
        [status, {"Location" => CGI.unescape(local_or_external_path(redirect_url))}, [status.to_s]]
      else
        self.send_to_radiant
      end
    end 
    
    def send_to_radiant
      [404, {'Content-Type' => 'text/html'}, ['Off to Radiant we go!']]
    end
  end
end
