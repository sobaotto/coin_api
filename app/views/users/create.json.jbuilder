# frozen_string_literal: true

json.extract! current_user, :id, :name, :email if current_user.present?
