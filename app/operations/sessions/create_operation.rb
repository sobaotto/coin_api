# frozen_string_literal: true

module Sessions
  class CreateOperation
    class << self
      def execute(params:)
        new(params: params).execute
      end
    end

    def initialize(params:)
      @user = User.find_by!(email: params[:email])
      @password = params[:password]
    end

    def execute
      @user.authenticate(@password)
    end
  end
end
