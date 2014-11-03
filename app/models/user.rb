class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #Validations added at testing section

  validates :first_name, presence: true

  validates :last_name, presence: true

  validates :profile_name, presence: true,
                         uniqueness: true,
                         format: {
                          with: /\A[a-zA-Z\-\_]+\z/,
                          message: 'must be formatted correctly.'
                         }


   # Relations declaration
   has_many :statuses

   # Method to return the full name
   def full_name
   	first_name + " " + last_name
   end


end
