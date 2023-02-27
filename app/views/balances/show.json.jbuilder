# frozen_string_literal: true

json.extract! current_user, :id, :balance if current_user.present?
