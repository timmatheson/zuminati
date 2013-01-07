class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protected

  def rentals_category
    Category.find(:first, conditions: {name: 'Rentals'}) || Category.create(name: 'Rentals')
  end

end
