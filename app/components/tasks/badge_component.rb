module Tasks
  class BadgeComponent < ViewComponent::Base
    def initialize(text:, css_class:, **html_options)
      super()
      @text = text
      extra_class = html_options.delete(:class)
      @css_class = [css_class, extra_class].compact.join(" ")
      @html_options = html_options
    end
  end
end
