ActionController::Routing::Routes.draw do |map|
  map.connect 'mailboxes/:mailbox/:id', :controller => "mailboxes", :action => "show"
  map.resources :mailboxes

  map.home '/', :controller => "clients", :action => "new"
  map.settings '/settings', :controller => "clients", :action => "show"

  map.signup '/signup', :controller => "clients", :action => "new"
  map.login '/login', :controller => "users", :action => "login"
  map.logout '/logout', :controller => "users", :action => "logout"
  map.assigned '/assigned', :controller => "mailboxes", :action => "show", :id => "assigned"
  map.closed '/closed', :controller => "mailboxes", :action => "show", :id => "closed"

  map.resources :tickets do |ticket|
    ticket.resources :mails
  end
  map.resources :mails
  map.resources :mailboxes do |mailbox|
    mailbox.resources :mails
  end

  map.resources :clients do |client|
    client.resources :users
  end
  map.resources :people
  map.resources :users

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
