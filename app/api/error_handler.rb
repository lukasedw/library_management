module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(message: e.message, status: 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error_response(message: e.record.errors.full_messages, status: 422)
    end
  end
end
