class API::RemoteUsersController < API::BaseAPIController
  # Login user By System request (internal dependences)
  def system_signup_signin
    # Except to eliminate the Attr from the Hash (it is a attr to another Model)
    input_hash = params['user']
    # Parse JSON String to Hash, if it is a String and abort if no user hash received
    if(input_hash.is_a?(String) && input_hash.length <= 1) then return render json: { status: 'error', type: :no_user_data, msg: 'No user Data received!' } end
    if input_hash.is_a?String then user_hash = JSON.parse(input_hash) else user_hash = input_hash end
    social_session_email = user_hash['social_session']['login']['email'] if user_hash.has_key?('social_session')

    # SELECT user WHERE email OR :email
    user = User.find_by_email([user_hash['email'],user_hash[:email], social_session_email])

    # SignUp
    if user.nil?
      user = User.persist_it(user_hash)

      if user.errors.messages.empty?
        response = {status: 'ok', msg: 'registered'}
      else
        response = {status: 'error', type: :invalid_attr_value, msg: user.errors.messages.to_json}
      end

      # End the user registration generating it API Token
      API::Concerns::TokenManager.new(user.email, user.password, params[:access_token])

    # SignIn
    else
      User.authenticate(user_hash['email'], user_hash['password'])
      response = { status: 'ok', msg: 'logged_in' }
    end

    # Send the response
    render json: response
  end

  # Login by token, without session
  def mob_login
    token_manager = API::Concerns::TokenManager.new(params[:email], params[:password], params[:access_token])
    current_user = token_manager.current_user
    if !current_user.nil?
      render json: JSON.parse(current_user.to_json).except('id', 'password', 'pass_salt', 'updated_at')
    else
      render json: JSON.parse(token_manager.token.to_json)
    end
  end

  # SocialNetwork Logins
  def social_login
    # Initializing the env
    network_class = params[:social_network_name].humanize
    network_obj = "Socials::#{network_class}".constantize.new

    # Setting the vars to be used on the View
    @network_login_url = network_obj.sign_up
    render json: {:"#{network_class.downcase}" => @network_login_url}
  end
end