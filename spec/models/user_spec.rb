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
  before { @user = User.new name: "Example User", email: "user@example.com", password: "foobar",
                            password_confirmation: "foobar" }

  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :authenticate }

  it { should be_valid }

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

  describe "can't save when email address is taken (case-insensitive)" do
    before do
      dup = @user.dup
      dup.email.swapcase!
      dup.save
    end
    it { expect {@user.save validate: false}.to raise_error(ActiveRecord::StatementInvalid) }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid}
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a"*5 }
    it { should be_invalid }
  end

  describe "when saving second account with different email" do
    before do
      dup = @user.dup
      dup.email = "user2@example.com"
      dup.save
    end
    it { should be_valid }
    specify { @user.save.should be_true }
  end

  describe "signup" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
