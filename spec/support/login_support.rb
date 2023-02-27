# frozen_string_literal: true

module LoginSupport
  def login(user: nil, email: nil, password: nil)
    login_params = {
      email: email || user&.email,
      password: password || user&.password
    }
    post login_path, params: login_params
  end
end
