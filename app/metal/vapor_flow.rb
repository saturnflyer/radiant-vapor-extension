require 'cgi'

class VaporFlow
  # Radiant must be restarted if the configuration changes for this setting
  @@use_regexp = nil
  class << self  
    def call(env)
      url = env["PATH_INFO"].sub(/^\//,'') #clean off the first slash, like it is stored in the db
      sql = "SELECT * FROM config where `key` = 'vapor.use_regexp'"
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
  
    def match_substitute(string, match)
      string.gsub(/\$([`&0-9'$])/) do |sub|
        case $1
        when "`": match.pre_match
        when "&": match[0]
        when "0".."9": puts $1.to_i; match[$1.to_i]
        when "'": match.post_match
        when "$": '$'
        end
      end
    end
  
    def radiant_path(redirect_url)
      '/' + redirect_url
    end
    
    def local_or_external_path(path)
      path.match(/https?:\/\//) ? path : self.radiant_path(path)
    end
   
    def catch_with_regexp(url)
      result = nil
      FlowMeter.all.sort.reverse.each do |meter|
        key = meter[0]
        value = meter[1]
        if (match = url.match(Regexp.new('^'+key)))
          status = value[1].to_i
          redirect_url = self.match_substitute(value[0], match)
          [status, {"Location" => CGI.unescape(self.local_or_external_path(redirect_url))}, [status.to_s]]
          break
        else
          result = self.send_to_radiant
          break
        end
      end
      result
    end
    
    def catch_without_regexp(url)
      a_match = FlowMeter.all[url]
      unless a_match.nil?
        status = a_match[1].to_i
        redirect_url = a_match[0]
        [status, {"Location" => CGI.unescape(self.local_or_external_path(redirect_url))}, [status.to_s]]
      else
        self.send_to_radiant
      end
    end 
    
    def send_to_radiant
      [404, {'Content-Type' => 'text/html'}, ['Off to Radiant we go!']]
    end
  end
end