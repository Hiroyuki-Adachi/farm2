require "test_helper"

# 定型用紙の変更と印刷指示の作成が別トランザクションで競合する場合のテスト。
# 別接続でコミット前の状態を作るため、トランザクションテストを使わない。
class PrintTemplateConcurrencyTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  WAIT_FOR_LOCK = 0.5
  THREAD_TIMEOUT = 10

  setup do
    @pdf = file_fixture("print_template.pdf").binread
    @new_pdf = "#{@pdf}\n% new"
    @template = PrintTemplate.create!(organization_id: 1, title: "競合試験用", pdf_data: @pdf)
  end

  teardown do
    PrintJob.where(print_template_id: @template.id).delete_all
    @template.delete
  end

  test "コミット前の印刷指示があると、コミットを待ってからPDFの変更を拒否する" do
    finish = Queue.new
    creator = hold_transaction(finish) { create_job }

    updater = in_thread do
      template = PrintTemplate.find(@template.id)
      template.pdf_data = @new_pdf
      [template.save, template.errors]
    end
    wait_for_lock(updater, release: finish, holder: creator, message: "印刷指示のコミット前にPDFの変更が終わってしまう")
    saved, errors = updater.join(THREAD_TIMEOUT).value

    assert_not saved
    assert errors.added?(:base, :pending_print_jobs)
    assert_equal @pdf.b, @template.reload.pdf_data.b
  end

  test "コミット前のPDF変更があると、コミットを待ってから印刷指示を受け付ける" do
    finish = Queue.new
    updater = hold_transaction(finish) { PrintTemplate.find(@template.id).update!(pdf_data: @new_pdf) }

    creator = in_thread { create_job }
    wait_for_lock(creator, release: finish, holder: updater, message: "PDFの変更のコミット前に印刷指示が登録されてしまう")
    creator.join(THREAD_TIMEOUT)

    assert_equal @new_pdf.b, @template.reload.pdf_data.b
    assert_equal 1, @template.print_jobs.pending.count
  end

  private

  # 別接続でブロックを実行する
  def in_thread(&)
    Thread.new { ActiveRecord::Base.connection_pool.with_connection(&) }
  end

  # 別接続のトランザクション内でブロックを実行し、finish に値が入るまでコミットしない
  def hold_transaction(finish, &)
    started = Queue.new
    thread = in_thread do
      ActiveRecord::Base.transaction do
        yield
        started << true
        finish.pop
      end
    end
    started.pop
    thread
  end

  # waiter がロック待ちになっていることを確認してから、holder のトランザクションをコミットさせる
  def wait_for_lock(waiter, release:, holder:, message:)
    assert_nil waiter.join(WAIT_FOR_LOCK), message
  ensure
    release << true
    holder.join(THREAD_TIMEOUT)
  end

  def create_job
    PrintJob.create!(organization_id: 1, print_template_id: @template.id, requested_by_id: users(:users1).id, copies: 1)
  end
end
