# frozen_string_literal: true

module Users
  class CreateOperation
    class << self
      def execute(params:)
        new(params: params).execute
      end
    end

    def initialize(params:)
      @params = params
    end

    def execute
      User.create!(@params)
    end
  end
end
