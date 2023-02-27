# frozen_string_literal: true

json.total_count @total_count
json.extract! current_user, :id, :balance if current_user.present?
json.histories @histories do |history|
  json.extract! history, :type, :amount, :created_at
end
