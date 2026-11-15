# 作業分類は参照元と同じ組織のものしか指定できないため、任意の組織に作業分類を用意する。
module WorkTypeHelpers
  def create_work_type_for(organization, name: "組織別分類", **attributes)
    category = WorkCategory.create!(organization: organization, name: name, display_order: 1)
    genre = WorkGenre.create!(category: category, name: name, display_order: 1)
    WorkType.create!(genre: genre, name: name, display_order: 1, **attributes)
  end
end

ActiveSupport.on_load(:active_support_test_case) { include WorkTypeHelpers }
