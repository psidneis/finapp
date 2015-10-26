class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :user_roles
  has_many :roles, through: :user_roles

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def current_user_roles
    self.user_roles.where(enabled: true).map{|r| r.role.title.parameterize.underscore}
  end

  def is?(role)
    role = [role].flatten.map{|r| r.to_s.parameterize.underscore}
    (self.current_user_roles & role).any?
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
