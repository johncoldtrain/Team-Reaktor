class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  private
	  def render_permission_error
	    render file: 'public/permission_error', status: :error, layout: false
	  end

	  def render_404
	    render file: 'public/404', status: :not_found
	  end

end
