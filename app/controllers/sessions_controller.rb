class SessionsController < Devise::SessionsController
 def new
   self.resource = resource_class.new {}
   store_location_for resource, params[:redirect_to]
   super
 end
end
