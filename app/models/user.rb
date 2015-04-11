class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :omniauth_providers => [:google_oauth2]

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

end
