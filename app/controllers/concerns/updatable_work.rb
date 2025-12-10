# app/controllers/concerns/updatable_work.rb
module UpdatableWork
  extend ActiveSupport::Concern

  included do
    helper_method :updatable_work? # view でも使えるようにする
  end

  # user を引数にしないで current_user を使う形に寄せるとスッキリ
  def updatable_work?(work)
    return false unless current_user && work

    (current_user.checkable? || work.created_by == current_user.worker.id) &&
      work.term == current_user.term
  end
end
