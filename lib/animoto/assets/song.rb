module Animoto
  module Assets
    class Song < Animoto::Assets::Base
      
      # The offset in seconds from the beginning denoting where to start
      # using this song in the video.
      # @return [Float]
      attr_accessor :start_time
      
      # The duration in seconds of how long this song should play.
      # @return [Float]
      attr_accessor :duration

      # The title of this song. Defaults to the title read from the metadata of
      # the source file.
      # @return [String]
      attr_accessor :title
      
      # The artist of this song. Default to the title read from the metadata of
      # the source file.
      # @return [String]
      attr_accessor :artist

      # Creates a new Song object.
      #
      # @param [String] source the source URL of this song
      # @param [Hash{Symbol=>Object}] options
      # @option options [Float] :start_time the time offset in seconds from the beginning of where to start playing this song
      # @option options [Float] :duration the length in seconds of how long to play this song
      # @option options [String] :title the title of this song. Defaults to being read from the song file's metadata
      # @option options [String] :artist the artist of this song. Defaults to being read from the song file's metadata
      # @return [Assets::Song] the Song object
      def initialize source, options = {}
        super
        @start_time = options[:start_time]
        @duration   = options[:duration]
        @title      = options[:title]
        @artist     = options[:artist]
      end
    
      # Returns a representation of this Song as a Hash.
      #
      # @return [Hash{String=>Object}] this asset as a Hash
      # @see Animoto::Assets::Base#to_hash
      def to_hash
        hash = super
        hash['start_time'] = start_time if start_time
        hash['duration'] = duration if duration
        hash['title'] = title if title
        hash['artist'] = artist if artist
        hash
      end
    
    end
  end
end