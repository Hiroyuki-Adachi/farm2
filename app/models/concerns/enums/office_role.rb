module Enums
  module OfficeRole
    extend ActiveSupport::Concern

    OFFICE_ROLE = {none: 0, finance: 1, general: 2, president: 9}.freeze

    included do
      enum :office_role, OFFICE_ROLE, prefix: true
    end

    class_methods do
      def office_role_value(key) = OFFICE_ROLE.fetch(key)
    end
  end
end
