class User < ApplicationRecord
  has_many :messages
  has_many :group_users
  has_many :groups, through: :group_users

  validates :name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
