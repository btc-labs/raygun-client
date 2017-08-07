module RaygunClient
  module HTTP
    class Post
      include Log::Dependency

      configure :raygun_post

      setting :api_key

      attr_reader :data

      dependency :telemetry, ::Telemetry

      def self.build
        new.tap do |instance|
          RaygunClient::Settings.set(instance)

          ::Telemetry.configure instance
        end
      end

      def self.call(data)
        instance = build
        instance.(data)
      end

      def call(data)
        logger.trace "Posting to Raygun"
        json_text = Transform::Write.(data, :json)

        response = post json_text

        record_posted data, response

        logger.info "Posted to Raygun (#{LogText::Posted.(data, response)})"

        response
      end

      def self.host
        'api.raygun.io'
      end

      def self.path
        '/entries'
      end

      def self.uri
        @uri ||= URI::HTTPS.build :host => host, :path => path
      end

      def record_posted(data, response)
        telemetry_data = Telemetry::Data.new data, response

        telemetry.record :posted, telemetry_data

        telemetry_data
      end

      def post(request_body)
        uri = self.class.uri

        Net::HTTP.start uri.host, uri.port, :use_ssl => uri.scheme == 'https' do |http|
          http.request_post uri.path, request_body, 'X-ApiKey' => api_key
        end
      end

      def self.register_telemetry_sink(post)
        sink = Telemetry.sink
        post.telemetry.register sink
        sink
      end

      def self.logger
        @logger ||= Log.get self
      end

      module Telemetry
        class Sink
          include ::Telemetry::Sink

          record :posted

          module Assertions
            def posts(&blk)
              if blk.nil?
                return posted_records
              end

              posted_records.select do |record|
                blk.call(record.data.data, record.data.response)
              end
            end

            def posted?(&blk)
              if blk.nil?
                return recorded_posted?
              end

              recorded_posted? do |record|
                blk.call(record.data.data, record.data.response)
              end
            end
          end
        end

        Data = Struct.new :data, :response

        def self.sink
          Sink.new
        end
      end

      module Substitute
        def self.build
          Substitute::Post.build.tap do |substitute|
            sink = RaygunClient::HTTP::Post.register_telemetry_sink(substitute)
            substitute.sink = sink
          end
        end

        class Post < Post
          attr_accessor :status_code
          attr_accessor :reason_phrase
          attr_accessor :sink

          def call(post_data)
            response = OpenStruct.new(
              :code => status_code,
              :message => reason_phrase
            )

            record_posted post_data, response
          end

          def set_response(status_code, reason_phrase: nil)
            self.reason_phrase = reason_phrase if reason_phrase
            self.status_code = status_code.to_s
          end

          def self.build
            new.tap do |instance|
              ::Telemetry.configure instance
            end
          end
        end
      end

      module LogText
        module Posted
          def self.call(data, response)
            "StatusCode: #{response.code}, ReasonPhrase: #{response.message}, ErrorMessage: #{data.error.message}, CustomData: #{data.custom_data || '(none)'})"
          end
        end
      end
    end
  end
end
