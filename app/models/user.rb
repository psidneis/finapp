class User < ActiveRecord::Base

  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :accounts
  has_many :cards
  has_many :lauches
  has_many :categories
  has_many :manager_groups, class_name: "Group", foreign_key: "user_id"

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(
          name: data["name"],
          email: data["email"],
          password: Devise.friendly_token[0,20]
        )
    end
    user
  end

end
