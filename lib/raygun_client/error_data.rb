module RaygunClient
  class ErrorData
    include Schema::DataStructure

    attribute :class_name, String
    attribute :message, String
    attribute :backtrace, Backtrace

    def backtrace
      @backtrace ||= Backtrace.new
    end

    def self.build(data=nil)
      unless data.nil?
        backtrace_data = data.delete(:backtrace)
      end

      instance = super

      unless backtrace_data.nil?
        instance.backtrace = Backtrace.build(backtrace_data)
      end

      instance
    end

    def set_backtrace(backtrace)
      self.backtrace = Backtrace.parse(backtrace)
    end

    def correspond?(error)
      error_corresponds = class_name == error.class.name &&
        message == error.message

      backtrace_corresponds = backtrace.text_frames == error.backtrace

      error_corresponds && backtrace_corresponds
    end

    def ==(other)
      return false if self.class != other.class

      this_hash = Transform::Write.raw_data(self)
      other_hash = Transform::Write.raw_data(other)

      this_hash == other_hash
    end

    def to_h
      data = attributes
      data[:backtrace] = backtrace.to_a
      data
    end

    module Transformer
      def self.json
        JSON
      end

      def self.instance(raw_data)
        ErrorData.build(raw_data)
      end

      def self.raw_data(instance)
        instance.to_h
      end

      module JSON
        def self.read(text)
          formatted_data = ::JSON.parse(text, symbolize_names: true)
          Casing::Underscore.(formatted_data)
        end

        def self.write(raw_data)
          formatted_data = Casing::Camel.(raw_data)
          ::JSON.generate(formatted_data)
        end
      end
    end
  end
end
