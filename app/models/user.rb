class User < ActiveRecord::Base

  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2, :twitter, :facebook]

  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :accounts, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :launches, dependent: :destroy
  has_many :installments, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :manager_groups, class_name: "Group", foreign_key: "user_id"
  has_many :notifications, dependent: :destroy

  before_save -> { skip_confirmation! }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.name
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
          password: Devise.friendly_token[0,20])
    end
    user
  end

  def current_notificatons
    self.notifications.where(check: false).order("created_at DESC")
  end

  def current_recurrence_launches
    self.launches.where(recurrence_type: 2, enabled: true)
  end

end
