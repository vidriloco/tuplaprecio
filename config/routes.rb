ActionController::Routing::Routes.draw do |map|
  map.resources :categorias

  map.logout '/logout', :controller => 'sesiones', :action => 'destroy'
  map.login '/login', :controller => 'sesiones', :action => 'new'
  map.register '/register', :controller => 'usuarios', :action => 'create'
  map.signup '/signup', :controller => 'usuarios', :action => 'new'
  map.tablero_principal '/principal', :controller => 'tableros', :action => 'index'
  
  
  #map.connect '/:controller/:action/:tipo', :controller=>"generalizados", :action=>"new"
  #map.connect '/:controller/:tipo/(.:format)', :controller=>"generalizados", :action=>"create"
  #map.connect '/:controller/:tipo/:action/:id', :controller=>"generalizados", :action=>"show"
  #map.connect '/:controller/:tipo/(.:format)', :controller=>"generalizados", :action=>"index"
  
  map.resources :usuarios

  map.resource :sesion

  map.resources :administraciones

  map.resources :conceptos

  map.resources :paquetes

  map.resources :plazas

  map.resources :servicios

  map.resources :estados
  
  map.resources :roles
  
  map.resources :incorporados
  
  map.resources :especializados
  
  map.resources :tableros
  
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "sesiones"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end