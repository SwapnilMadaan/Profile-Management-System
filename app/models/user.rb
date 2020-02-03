require 'elasticsearch/model'
class User < ApplicationRecord
	has_secure_password
	validates :user_contact, numericality: { only_integer: true, 
	message: "only digits allowed" }, length: { is: 10 }, uniqueness: true
	validates_presence_of :user_name, :password, :user_contact, :user_email, :user_catagory
	validates :user_email, uniqueness: { case_Sensitive: false,  message: "already taken" }

	has_many :children, :class_name => 'User'
	belongs_to :parent, :class_name => 'User', optional: true, :foreign_key => 'parent_id'
	

	after_commit on: [:create] do
		__elasticsearch__.index_document
	end
	
	after_commit on: [:update] do
		__elasticsearch__.update_document
	end
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks
	settings index: {number_of_shards: 1 } do
		mapping dynamic: 'false' do
		indexes :user_name, type: 'keyword'
		indexes :user_email, type: 'keyword'
		indexes :user_contact, type: 'keyword'
		end
	end


	
	before_commit  on: [:create,:update] do
		sibling = User.where(:parent_id=> self.parent_id).count
		if get_parents >=2  
    		errors.add(:category, "users limit for this parent execeded!Vertical Hieierchy !Please find another parent")
    		raise ActiveRecord::RecordInvalid.new(self)
    	else
    		if sibling >=4
       		errors.add(:category, "users limit for this parent execeded!Horizontal Hieierchy !Please find another parent")
    		raise ActiveRecord::RecordInvalid.new(self)

    	end
    end
  	end
  	
	
	def self.es_search_result(params)
		field = params[:field]
		query = params[:query]
		data  = self.__elasticsearch__.search({
			query: {
				bool: {
					must: [{
							term: {
								"#{field}": "#{query}"
								}

							}]

				 		}
					}
				}).records
		return data
	end

	
	def as_indexed_json(options={})
		self.as_json( {Name: user_name, email: user_email, phone: user_contact} )
	end


	#def self.insertion_in_es()
	#	User.__elasticsearch__.client.indices.create \
  	#	index: User.index_name,
	#	body: { settings: User.settings.to_hash, mappings: User.mappings.to_hash }
	#	User.find_each do |i|
	#		i.__elasticsearch__.index_document
	#	end
	#end
	def get_parents(result = 0)
  		if self.parent.present?
    		result+=1
    		self.parent.get_parents(result)
  		else
    		return result
  		end
	end

	def get_sibling( result = 0)
  		if(!self.children.empty?)
    		self.children.each do |child|
      		result+=1
    		end
  		end
    	return result
	end
    

		
end