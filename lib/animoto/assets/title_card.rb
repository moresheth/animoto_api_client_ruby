module Animoto
  module Assets
    class TitleCard
      # The main text of this title card.
      # @return [String]
      attr_accessor :title
      
      # The secondary text of this title card.
      # @return [String]
      attr_accessor :subtitle
    
      # Whether or not this image is spotlit. Spotlighting a visual tells to director to add
      # more emphasis to this visual when directing.
      # @return [Boolean]
      attr_writer :spotlit
      
      # Returns whether or not this image is spotlit.
      # @return [Boolean]
      def spotlit?
        @spotlit
      end
      
      # Creates a new TitleCard.
      #
      # @param [String] title the main text
      # @param [String] subtitle the secondary text
      # @param [Hash{Symbol=>Object}] options
      # @option options [Boolean] :spotlit whether or not to spotlight this title card
      # @return [Assets::TitleCard] the TitleCard object
      def initialize title, subtitle = nil, options = {}
        @title, @subtitle = title, subtitle
        @spotlit = options[:spotlit]
      end
    
      # Returns a representation of this TitleCard as a Hash.
      #
      # @return [Hash{String=>Object}] this TitleCard as a Hash
      def to_hash
        hash = {}
        hash['h1'] = title
        hash['h2'] = subtitle if subtitle
        hash['spotlit'] = spotlit? unless @spotlit.nil?
        hash
      end
    end
  end
end