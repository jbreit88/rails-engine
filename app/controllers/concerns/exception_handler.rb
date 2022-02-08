module ExceptionHandler
  # provides the more graceful 'included' methods
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end

# In our create method in TodosController we are using create! instead of create. This way the model will raise an exception ActiveRecord:RecordInvalid. This way we avoid deep nested if statements in our controller and we rescue from the exception in the ExceptionHandler.
