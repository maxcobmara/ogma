class Subdomain
   def matches?(request)
     #request.subdomain.present? && request.subdomain !="www" #works fine at local
     #request.subdomain(2).present? && request.subdomain(2) !="www"  #required at remote svr
     request.subdomain(4).present? && request.subdomain(4) !="www"
   end
end
