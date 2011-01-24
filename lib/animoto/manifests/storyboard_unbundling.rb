module Animoto
  module Manifests
    class StoryboardUnbundling < Animoto::Manifests::Base
      
      # The URL to the storyboard bundle
      # @return [String]
      attr_accessor :bundle_url
      
      # Creates a new storyboard unbundling manifest
      # Unbundling a storyboard "rehydrates" the assets and directorial decisions associated with
      # this project, allowing the video to be rendered even if the original storyboard or visual
      # assets have expired or been deleted on Animoto's servers since they were created the first
      # time.
      #
      # @param [Hash{Symbol=>Object}] options
      # @option options [String] :bundle_url the URL pointing to a storyboard bundle
      # @option options [String] :http_callback_url a URL to receive a callback when this job is done
      # @option options [String] :http_callback_format the format of the callback
      def initialize options = {}
        super
        @bundle_url = options[:bundle_url]
      end
      
      # Returns a representation of this manifest as a Hash.
      #
      # @return [Hash{String=>Object}] this manifest as a Hash
      # @raise [ArgumentError] if a callback URL is specified but not the format
      def to_hash
        hash  = { 'storyboard_unbundling_job' => { 'storyboard_unbundling_manifest' => {} } }
        job   = hash['storyboard_unbundling_job']
        add_callback_information job
        manifest = job['storyboard_unbundling_manifest']
        manifest['storyboard_bundle_url'] = bundle_url
        hash
      end
      
    end
  end
end