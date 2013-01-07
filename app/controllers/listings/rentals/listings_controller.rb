class Listings::Rentals::ListingsController < ListingsController
	def index
		@listings = rentals_category.listings.paginate(:per_page => 25, :page => params[:page])
	end
end