module Tasks
  class BadgeComponent < ViewComponent::Base
    def initialize(text:, css_class:, **html_options)
      super()
      @text = text
      @css_class = css_class
      @html_options = html_options
    end
  end
end
