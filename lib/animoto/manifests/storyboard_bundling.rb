module Animoto
  module Manifests
    class StoryboardBundling < Animoto::Manifests::Base
      
      # The storyboard to be bundled
      # @return [Resources::Storyboard]
      attr_accessor :storyboard
      
      # Creates a new storyboard bundling manifest.
      # A storyboard bundle is a archive of the assets and directorial decisions associated
      # with this project. Once a storyboard is bundled, if the original storyboard on Animoto's
      # servers expires or is deleted, the storyboard can be reconstructed from the bundle and
      # the video can be rendered.
      #
      # @param [Resources::Storyboard] storyboard the storyboard to bundle
      # @param [Hash{Symbol=>Object}] options
      # @option options [String] :http_callback_url a URL to receive a callback when this job is done
      # @option options [String] :http_callback_format the format of the callback
	  def initialize options = {}
        super
        @storyboard = options[:storyboard]
      end     
      # Returns a representation of this manifest as a Hash.
      #
      # @return [Hash{String=>Object}] this manifest as a Hash
      # @raise [ArgumentError] if a callback URL is specified but not the format
      def to_hash
        hash  = { 'storyboard_bundling_job' => { 'storyboard_bundling_manifest' => {} } }
        job   = hash['storyboard_bundling_job']
        add_callback_information job
        manifest = job['storyboard_bundling_manifest']
        manifest['storyboard_url'] = storyboard.url if storyboard
        hash
      end      
    end
  end
end