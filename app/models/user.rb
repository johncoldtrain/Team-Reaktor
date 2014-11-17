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
                          with: /\A[a-zA-Z0-9\-\_]+\z/,
                          message: 'must be formatted correctly.'
                         }


   # Relations declaration
   has_many :statuses
   has_many :user_friendships

   # Special declaration since we are using an indirect attribute
   has_many :friends, through: :user_friendships

   # Method to return the full name
   def full_name
   	first_name + " " + last_name
   end

   # To create the hashed URL for Gravatar
   def gravatar_url
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)

    "http://gravatar.com/avatar/#{hash}"
   end


end
