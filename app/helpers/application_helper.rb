module ApplicationHelper
  def gravatar(email)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "https://gravatar.com/avatar/#{gravatar_id}?s=48"
  end
end
