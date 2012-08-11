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
  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, email_format: true, uniqueness: { case_sensitive: false }

  before_save do |user|
    user.email_lower = email.downcase
  end
end
