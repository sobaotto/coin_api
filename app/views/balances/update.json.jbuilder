# frozen_string_literal: true

json.extract! current_user.reload, :id, :balance if current_user.present?
