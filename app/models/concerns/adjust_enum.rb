module AdjustEnum
  extend ActiveSupport::Concern

  class_methods do
    def define_adjust_enum(column)
      enum column, {none: 0, hour: 1, area: 2, day: 3}, prefix: true
    end
  end
end
