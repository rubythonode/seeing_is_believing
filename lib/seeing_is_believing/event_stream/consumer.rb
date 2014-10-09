require 'seeing_is_believing/event_stream/events'
require 'seeing_is_believing/error'
class SeeingIsBelieving
  module EventStream
    class Consumer
      NoMoreInput        = Class.new SeeingIsBelievingError
      WtfWhoClosedMyShit = Class.new SeeingIsBelievingError

      def initialize(readstream)
        @readstream = readstream
      end

      def call(n=1)
        events = n.times.map do
          raise NoMoreInput if finished?
          line = @readstream.gets
          raise NoMoreInput if line.nil?
          event = event_for line
          @finished = true if Events::Finish === event
          event
        end
        n == 1 ? events.first : events
      rescue IOError
        @finished = true
        raise WtfWhoClosedMyShit, "Our end of the pipe was closed!"
      rescue NoMoreInput
        @finished = true
        raise
      end

      def each
        return to_enum :each unless block_given?
        loop do
          event = call
          yield event unless Events::Finish === event
        end
      rescue NoMoreInput
        return nil
      end

      def finished?
        @finished
      end

      private

      def extract_token(line)
        event_name = line[/[^ ]+/]
        line.sub! /^\s*[^ ]+\s*/, ''
        event_name
      end

      # for a consideration of many different ways of doing this, see 5633064
      def extract_string(line)
        Marshal.load extract_token(line).unpack('m0').first
      end

      def tokenize(line)
        line.split(' ')
      end

      def event_for(line)
        line.chomp!
        event_name = extract_token(line).intern
        case event_name
        when :result
          line_number = extract_token(line).to_i
          type        = extract_token(line).intern
          inspected   = extract_string(line)
          Events::LineResult.new(type, line_number, inspected)
        when :maxed_result
          line_number = extract_token(line).to_i
          type        = extract_token(line).intern
          Events::UnrecordedResult.new(type, line_number)
        when :exception
          Events::Exception.new(-1, '', '', []).tap do |exception|
            loop do
              line = @readstream.gets.chomp
              case extract_token(line).intern
              when :line_number   then exception.line_number = extract_token(line).to_i
              when :class_name    then exception.class_name  = extract_string(line)
              when :message       then exception.message     = extract_string(line)
              when :backtrace     then exception.backtrace << extract_string(line)
              when :end           then break
              end
            end
          end
        when :stdout
          Events::Stdout.new(extract_string line)
        when :stderr
          Events::Stderr.new(extract_string line)
        when :max_line_captures
          token = extract_token(line)
          value = token =~ /infinity/i ? Float::INFINITY : token.to_i
          Events::MaxLineCaptures.new(value)
        when :exitstatus
          # TODO: Will this fuck it up if you run `exit true`?
          Events::Exitstatus.new(extract_token(line).to_i)
        when :finish
          Events::Finish.new
        when :num_lines
          Events::NumLines.new(extract_token(line).to_i)
        when :sib_version
          Events::SiBVersion.new(extract_string line)
        when :ruby_version
          Events::RubyVersion.new(extract_string line)
        else
          raise "IDK what #{event_name.inspect} is!"
        end
      end
    end
  end
end
