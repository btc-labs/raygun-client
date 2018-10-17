module RaygunClient
  class Publish
    include Dependency
    include Initializer

    initializer :error, :tags

    attr_writer :custom_data
    def custom_data
      @custom_data ||= {}
    end

    dependency :clock, Clock::UTC
    dependency :post, HTTP::Post

    def configure
      Clock::UTC.configure(self)
      HTTP::Post.configure(self, attr_name: :post)
    end

    def self.build(error, tag: nil, tags: nil, custom_data: nil)
      tags = Array(tags)
      tags << tag unless tag.nil?

      custom_data ||= {}

      instance = new(error, tags)
      instance.custom_data = custom_data
      instance.configure
      instance
    end

    def self.call(error, **args)
      instance = build(error, **args)
      instance.()
    end

    def call
      raygun_data = Data.new
      raygun_data.occurred_time = clock.iso8601
      raygun_data.machine_name = Socket.gethostname
      raygun_data.client = Data::ClientInfo.build
      raygun_data.tags = self.tags
      raygun_data.custom_data = custom_data

      error_data = ErrorData::Convert::Error.(error)

      raygun_data.error = error_data

      response = post.(raygun_data)

      response
    end
  end
end
