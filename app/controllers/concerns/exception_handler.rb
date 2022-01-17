module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    # rescue_from ActiveRecord::RecordInvalid do |e|
    #   json_response({ message: e.message }, :unprocessable_entity)
    # end
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(eee)
    json_response({ message: eee.message }, :unprocessable_entity)
  end

  # JSON response with message; Status code 401 - Unauthorized
  def unauthorized_request(eee)
    json_response({ message: eee.message }, :unauthorized)
  end
end
