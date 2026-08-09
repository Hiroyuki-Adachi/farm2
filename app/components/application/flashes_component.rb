module Application
  class FlashesComponent < ViewComponent::Base
    BOOTSTRAP_CLASSES = {
      "notice" => "alert-success",
      "alert" => "alert-warning",
      "error" => "alert-danger"
    }.freeze

    def initialize(flash:)
      super()
      @flash = flash
    end

    private

    def bootstrap_class(type)
      BOOTSTRAP_CLASSES.fetch(type.to_s, "alert-info")
    end
  end
end
