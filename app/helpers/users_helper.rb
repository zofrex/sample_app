module UsersHelper
  def gravatar_for user
    gravatar_id = Digest::MD5::hexdigest user.email_lower
    gravatar_url = "//secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end
end
