# Be sure to restart your server when you modify this file.

Ogma::Application.config.session_store :cookie_store, key: '_ogma_session', :domain => :all
#meanwhile use ABOVE line first, using below may coz -- Can't verify CSRF token authenticity during signing in. 
#Ogma::Application.config.session_store :cookie_store, key: '_ogma_session', :domain => "teknikpadu.com.my" #use this for Linode - remote server - ONLY when teknikpadu.com.my AVAILABLE!!!
