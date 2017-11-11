module RaygunClient
  class ErrorData
    module Convert
      module Error
        def self.call(standard_error)
          error_data = ErrorData.build

          error_data.class_name = standard_error.class.name
          error_data.message = standard_error.message

          error_data.set_backtrace(standard_error.backtrace)

          error_data
        end
      end
    end
  end
end
