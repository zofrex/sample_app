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

require 'spec_helper'

describe User do
  before { @user = User.new name: "Example User", email: "user@example.com" }

  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    addresses = %w[
      NotAnEmail
      @NotAnEmail
      .wooly@example.com
      wo..oly@example.com
      pootietang.@example.com
      .@example.com
      Ima\ Fool@example.com
      user@foo,com
      user_at_foo.org
      example.user@foo.
      foo@bar_baz.com
      foo@bar+baz.com
    ]

    addresses.each do |invalid_address|
      describe ": #{invalid_address}" do
        before { @user.email = invalid_address }
        it { should_not be_valid }
      end
    end
  end

  describe "when email format is valid" do
    addresses = %w[
      joe@example.com
      "Abc\\@def"@example.com
      "Fred\\\ Bloggs"@example.com
      "Joe.\\\\"Blow@example.com
      customer/department=shipping@example.com
      $A12345@example.com
      !def!xyz%abc@example.com
      _somename@example.com
      user@foo.COM
      A_US-ER@f.b.org
      frst.lst@foo.jp
      a+b@baz.cn
    ]
    addresses.each do |valid_address|
      describe ": #{valid_address}" do
        before { @user.email = valid_address }
        it { should be_valid }
      end
    end
  end

  describe "invalid when email address is taken" do
    before { @user.dup.save }
    it { should_not be_valid }
  end

  describe "invalid when email address is taken (case-insensitive)" do
    before do
      dup = @user.dup
      dup.email.swapcase!
      dup.save
    end
    it { should_not be_valid }
  end

  describe "can't save when email address is taken" do
    before { @user.dup.save }
    it { expect {@user.save validate: false}.to raise_error(ActiveRecord::StatementInvalid) }
  end
end
