class User < ActiveRecord::Base
  # Relations
  has_many :profiles
  has_many :campaigns
  has_many :social_sessions

  # Custom validations
  validate :solve_locale
  validate :encrypt_password

  # Rails validations
  validates :name, presence: true, length: { in: 3..55 }, on: [:create, :update]
  validates :nick, presence: true, length: { in: 2..30 }, uniqueness: true, on: [:create, :update]
  validates :email, presence: true, length: { in: 5..55 }, uniqueness: true, on: [:create, :update]
  validates :locale, presence: true, length: { is: 5 }, on: [:create, :update]

  # Validates Associations

  # Encrypt the pasword using BCrypt
  def encrypt_password
    if password.present? && !pass_salt.present?
      self.pass_salt = BCrypt::Engine.generate_salt
      self.password = BCrypt::Engine.hash_secret(password, pass_salt)
    end
  end

  # Auth user
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password == BCrypt::Engine.hash_secret(password, user.pass_salt) then user else nil end
  end

  # Solve the idiom issues
  def solve_locale
    # Refect locale for optimized Locale (pt_PT != pt_BR)
    if self.locale == 'pt' then self.locale = 'pt'+'_BR'
    elsif self.locale == 'en' then self.locale = 'en'+'_US'
    elsif self.locale.length != 5 then self.locale = 'en'+'_US' end
  end

  # Return it first name
  def first_name
    # Regex, return the first word (split the name based on the spaces)
    self.name.split(/ /)[0]
  end

  # Method that encapsulate the User creation rule
  def self.create_one_user user_hash
    user_hash_full = user_hash
    return_user = User.new(user_hash.except('role'))

    # Prevent the user with no role to be created
    role = Role.find_by_name(user_hash_full['role'])
    if role.nil? then role_id = nil else role_id = role.id end

    return_user.profiles = [].append Profile.new({ name: '', default_role: true, role_id: role_id })

    case role_id
      when 1
        second_role = 2
      when 2
        second_role = 1
    end

    return_user.profiles.append(Profile.new({ name: '', default_role: true, role_id: second_role }))
    return_user
  end

  # Return the User default Account
  def get_default_profile
    self.profiles.each do |profile|
      return profile if profile.default_role == true
    end
  end

  # Set the current actived (rendered) profile as default
  def set_default_profile role_name
    profiles.each do |profile|
      if profile.role.name != role_name then default = false else default = true end
      profile.update(default_role: default)
    end
  end

  # Create an user_hash (instanciable) from a social_hash RETURNS: [:user] & [:social_session]
  def self.create_user_hash_from_social social_hash
    user = social_hash['login']
    pages = social_hash['pages']['data']

    hash_return = {:user => {}, :social_session => {}}

    hash_return[:user] = {name: user['name'], nick: user['username'], email: user['email'], locale: user['locale'], 'role' => 'publisher'}
    hash_return[:social_session] = {id_on_social: user['id'], name: user['name'], username: user['username'], email: user['email'], gender: user['gender'], locale: user['locale'], gender: user['gender'], count_friends: user['count_friends'], social_network_id: user['network_id']}
    hash_return[:pages] = []

    # Append the pages
    pages.each do |page|
      page = page[1] if page.is_a?Array
      hash_return[:pages].append({ id_on_social: page['id'], name: page['name'], category: page['category'], access_token: page['access_token'] })
    end

    hash_return
  end
end
