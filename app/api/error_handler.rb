module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      error!("We can't find the resource.", 404)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!(e.record.errors.full_messages, 422)
    end

    rescue_from Pundit::NotAuthorizedError do |e|
      error!("You are not authorized to perform this action.", 403)
    end
  end
end
