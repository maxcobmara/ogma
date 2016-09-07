class Subdomain
   def matches?(request)
     #request.subdomain.present? && request.subdomain !="www" #works fine at local, http://lvh.me --> http://amsas.lvh.me, http://kskbjb.lvh.me
     request.subdomain(2).present? && request.subdomain(2) !="www"  #use this for production mode @ remote svr, http://teknikpadu.com.my --> http://amsas.teknikpadu.com.my, http://kskbjb.teknikpadu.com.my
   end
end
