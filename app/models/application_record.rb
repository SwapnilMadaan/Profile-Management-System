class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
   #enum status: [:owner, :broker, :user]
end
