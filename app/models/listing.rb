class Listing < ActiveRecord::Base
  attr_accessible :bedrooms, :address, :category_id, :city, :country, :description, :email, :featured, :phone, :price, :source, :spam, :state, :title, :url, :zipcode

  has_many :custom_attributes, :foreign_key => :owner_id

  belongs_to :user
  belongs_to :category

  geocoded_by :full_address
  after_validation :geocode, :populate_address_fields

  validates :price, presence: true
  validates :title, presence: true
  validates :image_url, presence: true

  searchable do
    text :title, :default_boost => 2
    text :city
    text :state
    text :description
    double :price
    double :bedrooms
    double :sqrft
  end

  def full_address
    [address, city, state, zipcode, country].compact.join(" ")
  end

  private

  def populate_address_fields
    geocode_result = Geocoder.search(full_address)
    unless geocode_result.empty?
      first_address = geocode_result.first
      self.address = first_address.address
      self.city    = first_address.city
      self.state   = first_address.state
      self.zipcode = first_address.postal_code
      self.country = first_address.country
    end
  end
end
