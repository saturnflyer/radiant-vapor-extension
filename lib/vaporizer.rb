module Vaporizer
  def self.included(klass)
    klass.instance_eval do
      extend  ClassMethods
      include InstanceMethods
    end
  end

  module ClassMethods
    def catch_url_match_with_regexp(url)
      result = nil
      FlowMeter.all.sort.reverse.each do |meter|
        prepared_url = cleaned_up_path(meter[0])
        prepared_url = radiant_path(prepared_url)
        if (match = url.match(Regexp.new('^'+prepared_url)))
          return meter[0]
          break
        end
      end
      return result
    end
    
    def catch_url_match(url)
      url = cleaned_up_path(url)
      a_match = FlowMeter.all[url]
      a_match ? url : nil
    end
    
    def cleaned_up_path(path)
      new_path = path.gsub(%r{//+},'/').gsub(%r{\s+},'')
      new_path.gsub!(%r{\/$},'') unless new_path == '/'
      new_path.gsub!(%r{^/},'') unless new_path == '/'
      new_path
    end
    
    def radiant_path(path)
      return path if path == '/'
      '/' + path
    end
    
    def local_or_external_path(path)
      path.match(/https?:\/\//) ? path : self.radiant_path(path)
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
  end

  module InstanceMethods
    def local_or_external_redirect_url
      self.class.local_or_external_path(redirect_url)
    end
    
    def cleaned_up_path(path)
      self.class.cleaned_up_path(path)
    end
    
    def radiant_path(path)
      self.class.radiant_path(path)
    end
  end
end