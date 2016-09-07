module UrlHelper
  def with_subdomain(subdomain)
    subdomain = (subdomain || "")
    subdomain+="." unless subdomain.empty?
    #[subdomain, request.domain, request.port_string].join #works fine at local, http://lvh.me --> http://amsas.lvh.me, http://kskbjb.lvh.me
    [subdomain, request.domain(2), request.port_string].join #use this for production mode @ remote svr, http://teknikpadu.com.my --> http://amsas.teknikpadu.com.my, http://kskbjb.teknikpadu.com.my
  end
  
  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:subdomain)
      options[:host]=with_subdomain(options.delete(:subdomain))
    end
    super
  end
end