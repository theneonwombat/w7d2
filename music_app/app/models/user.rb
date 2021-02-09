class User < ApplicationRecord 

  validates :session_token, :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}

  attr_reader :password

  before_validation :ensure_session_token

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
  
  def reset_session_token
    self.session_token ||= User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def check_password?(password)
    password_object = BCrypt::Password.new(password)
    password_object.is_password?(password)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(id: params[:id])

    if user && user.check_password?(password)
      return user
    else
      return nil
    end
  end
  
end
