class User < ActiveRecord::Base
  # attr_accessible :email, :password, :password_confirmation
 
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :phone
  validates_uniqueness_of :phone
  
  def self.authenticate(phone, password)
    user = find_by_phone(phone)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if self.password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone, :password, :password_confirmation, :name)
  end

end
