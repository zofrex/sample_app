# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  attr_readonly :email_lower

  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, email_format: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  before_save do |user|
    user.email_lower = email.downcase
  end
end
