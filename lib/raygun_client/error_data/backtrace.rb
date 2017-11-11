module RaygunClient
  class ErrorData
    class Backtrace
      include Schema::DataStructure

      def frames
        @frames ||= []
      end

      def self.build(data=nil)
        data ||= []
        new.tap do |instance|
          data.each do |frame|
            instance.frames << Frame.build(frame)
          end
        end
      end

      def add_frame(frame)
        frames << frame
        self
      end
      alias :<< :add_frame

      def each(&blk)
        frames.each &blk
      end

      def text_frames
        frames.map do |frame|
          frame.to_s
        end
      end

      def to_a
        frames.map do |frame|
          frame.to_h
        end
      end

      def self.parse(backtrace)
        instance = new

        backtrace.each do |frame|
          instance.add_frame(Frame.parse(frame))
        end

        instance
      end
    end
  end
end
