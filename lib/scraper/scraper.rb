#encoding: utf-8
require 'typhoeus'
require 'nokogiri'

module Scraper
	module Processors

		def self.lookup_category( name )
			Category.find(:first, conditions: {name: name}) || Category.create(name: name)
		end

		class Craigslist < Listing
			attr_accessor :link

			def self.process(category_name, data)
				data = Nokogiri(data)
				data.xpath('//p[@class="row"]/a').each do |link|
					listing = self.find_by_url(link.attr('href')) || self.new(:url => link.attr('href'))
					listing.category = Processors::lookup_category(category_name)
					listing.spam     = false
					listing.source   = self.class.to_s
					listing.link     = link
					listing.parse!
				end
			end

			def parse!
				# capture the title
				self.title       = extract_title

				# capture the description
				self.description = extract_description

				# capture the email
				self.email       = extract_email

				# capture the phone
				self.phone       = extract_phone

				# capture the image
				self.image_url   = extract_image

				# capture the price
				self.price       = extract_price

				# capture the bedrooms
				self.bedrooms    = extract_bedrooms

				# capture the sqrft
				self.sqrft       = extract_sqrft

				puts self.inspect

				if self.save
					puts "Saving....."
					puts "Saved #{self.title}"
					puts
				end
			end

			private

			def extract_title
				@link.text
			end

			def extract_price
				@request.body.scan(/\$\d+/).first.to_s.gsub(/[^0-9]/,'') rescue nil
			end

			def extract_description
				@request = Typhoeus::Request.get(self.url)
				if @request.success?
					Nokogiri(@request.body).xpath('//section[@id="userbody"]').text.html_safe
				else
					''
				end
			end

			def extract_image
				if im = Nokogiri(@request.body).xpath('//img').first.attr('src') rescue nil
					im_request = Typhoeus::Request.get(im)
					if im_request.success?
						name = im.split("/").last
						path = Rails.root.join('public','images', name)
						if !File.exists?(path)
							io = File.new(path, 'w+')
							io.binmode
							io.write(im_request.body)
							io.close
						end
						return "/images/#{name}"
					else
						return nil
					end
				else
					return nil
				end
			end

			def extract_email
				@request.body.scan(/\w+@\w+\.\w+/).first rescue nil
			end

			def extract_phone
				Nokogiri(@request.body).xpath('//section[@id="userbody"]').text.scan(/\d{3}-?\d{3}-?\d+{4}/).first.gsub(/[^0-9]/,'') rescue nil
			end

			def extract_address
				nil
			end

			def extract_bedrooms
				@request.body.scan(/(\d+)\s?(br|bd|bedroom|bdr)/i).flatten.first rescue nil
			end

			def extract_sqrft
				@request.body.scan(/(\d+)\s?(sqft|sq|ft)/i).flatten.first rescue nil
			end
		end

	end
end

#Listing.destroy_all

SPAM_CHARS = /\*\<\>/

TARGET = 'http://orangecounty.craigslist.org/search/%s?query=&srchType=A&zoomToPosting=&minAsk=&maxAsk=&bedrooms=&hasPic=1&s=%s'
bedrooms_index = 1
page = (Listing.count/100).ceil
param = ''

category = 'apa'

Listing.destroy_all

while true
	url = TARGET % [category,page]
	puts "Fetching: #{url}"
	request = Typhoeus::Request.get(url)

	if request.success?
		Scraper::Processors::Craigslist.process('Rentals', request.body)
		page += 100
		param = "index#{page}.html"
		if page >= 500
			category = 'rea'
			page = 1
		end
		break if page >= 1000
	else
		puts "Exiting on failure"
		break
	end
end