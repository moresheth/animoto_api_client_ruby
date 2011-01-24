module Animoto
  module Resources
    module Jobs
      class StoryboardUnbundling < Animoto::Resources::Jobs::Base
        
        # @return [Hash{Symbol=>Object}]
        # @see Animoto::Support::StandardEvelope::ClassMethods#unpack_standard_envelope
        def self.unpack_standard_envelope body
          links = unpack_links(body)
          super.merge({
            :storyboard_url => links['storyboard']
          })
        end
        
        # The storyboard created by this job.
        # @return [Resources::Storyboard]
        attr_reader :storyboard

        # The URL to the storyboard resource.
        # @return [String]
        attr_reader :storyboard_url
                
        # @return [Jobs::StoryboardUnbundling]
        # @see Animoto::Jobs::Base#instantiate
        def instantiate attributes = {}
          @storyboard_url = attributes[:storyboard_url]
          @storyboard     = Animoto::Resources::Storyboard.new(:url => @storyboard_url) if @storyboard_url
          super
        end
      
      end
    end
  end
end