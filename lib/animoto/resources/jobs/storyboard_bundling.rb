module Animoto
  module Resources
    module Jobs
      class StoryboardBundling < Animoto::Resources::Jobs::Base
        
        # @return [Hash{Symbol=>Object}]
        # @see Animoto::Support::StandardEvelope::ClassMethods#unpack_standard_envelope
        def self.unpack_standard_envelope body
          links = unpack_links(body)
          super.merge({
            :bundle_url => links['bundle']
          })
        end
        
        # The URL to the storyboard resource.
        # @return [String]
        attr_reader :bundle_url
        
        # @return [Jobs::StoryboardBundling]
        # @see Animoto::Jobs::Base#instantiate
        def instantiate attributes = {}
          @bundle_url = attributes[:bundle_url]
          super
        end
      
      end
    end
  end
end