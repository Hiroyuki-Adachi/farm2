module CrawlersTestHelper
  def read_fixture(filename)
    Rails.root.join("test/fixtures/html/#{filename}").read
  end
end
