class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   # Relations declaration
   has_many :statuses

   # Method to return the full name
   def full_name
   	first_name + " " + last_name
   end


end
