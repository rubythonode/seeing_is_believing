require 'seeing_is_believing/event_stream/events'
class SeeingIsBelieving
  module EventStream
    # Adapter between EventStream and Result
    class UpdateResultHandler
      include EventStream::Events

      attr_reader :result

      def initialize(result)
        @result = result
      end

      def call(event)
        case event
        when LineResult       then result.record_result(event.type, event.line_number, event.inspected)
        when UnrecordedResult then result.record_result(event.type, event.line_number, '...') # <-- is this really what I want?
        when Exception        then result.record_exception event.line_number, event.class_name, event.message, event.backtrace
        when Stdout           then result.stdout            << event.value
        when Stderr           then result.stderr            << event.value
        when MaxLineCaptures  then result.max_line_captures = event.value
        when Exitstatus       then result.exitstatus        = event.value
        when NumLines         then result.num_lines         = event.value
        when SiBVersion       then result.sib_version       = event.value
        when RubyVersion      then result.ruby_version      = event.value
        when Filename         then result.filename          = event.value
        when Exec,
             Finished,
             StdoutClosed,
             StderrClosed,
             EventStreamClosed
             # no op
        else raise "Unknown event: #{event.inspect}"
        end
      end

      def ==(other)
        other.kind_of?(self.class) # this is dumb, it's b/c Result doesn't correctly implement ==
      end

      def return_value
        result
      end
    end
  end
end