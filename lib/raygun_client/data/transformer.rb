module RaygunClient
  class Data
    module Transformer
      def self.json
        JSON
      end

      def self.raw_data(instance)
        instance.to_h
      end

      module JSON
        def self.write(raw_data)
          formatted_data = Casing::Camel.(raw_data)
          ::JSON.generate(formatted_data)
        end
      end
    end
  end
end
