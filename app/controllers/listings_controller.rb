class ListingsController < ApplicationController
  before_filter :authenticate_user!, except: [:index,:show]

  # GET /listings
  # GET /listings.json
  def index
    if params[:q] || params[:filter]
      @search = Listing.search do
        paginate :page => params[:page], :per_page => 25
        keywords(params[:q])
        any_of do
          if params[:price].present?
            with(:price, Range.new( params[:price].split("-").first, params[:price].split("-").last))
          end

          if params[:bedrooms].present?
            with(:bedrooms, Range.new( params[:bedrooms].split("-").first, params[:bedrooms].split("-").last))
          end

          if params[:square_footage].present?
            with(:sqrft, Range.new( params[:square_footage].split("-").first, params[:square_footage].split("-").last))
          end
        end

      end
      @listings = @search.results
    else
      @listings = Listing.paginate(:per_page => 25, :page => params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @listing = Listing.find(params[:id])

    params[:q] = @listing.city.to_s

    @search = Listing.search do
      keywords( params[:q] )
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @listing }
    end
  end

  # GET /listings/new
  # GET /listings/new.json
  def new
    @listing = current_user.listings.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @listing }
    end
  end

  # GET /listings/1/edit
  def edit
    @listing = current_user.listings.find(params[:id])
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = current_user.listings.new(params[:listing])

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render json: @listing, status: :created, location: @listing }
      else
        format.html { render action: "new" }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /listings/1
  # PUT /listings/1.json
  def update
    @listing = current_user.listings.find(params[:id])

    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing = current_user.listings.find(params[:id])
    @listing.destroy

    respond_to do |format|
      format.html { redirect_to listings_url }
      format.json { head :no_content }
    end
  end
end
