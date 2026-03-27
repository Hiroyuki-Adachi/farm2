require 'test_helper'

class ImportJmaJobTest < ActiveJob::TestCase
  test "submit uses landing cookies and current params" do
    job = ImportJmaJob.new

    landing_response = fake_response(
      success: true,
      cookies: ["ci_session=abc123; path=/", "AWSALB=def456; path=/"]
    )

    request_response = fake_response(success: true)

    request = Minitest::Mock.new
    request.expect(:[]=, "ci_session=abc123; AWSALB=def456", ["Cookie", "ci_session=abc123; AWSALB=def456"])
    request.expect(:[]=, "https://www.data.jma.go.jp/risk/obsdl/", ["Referer", "https://www.data.jma.go.jp/risk/obsdl/"])
    request.expect(:[]=, "https://www.data.jma.go.jp", ["Origin", "https://www.data.jma.go.jp"])
    request.expect(:set_form_data, true, [job.send(:submit_params, 2025)])

    http = Minitest::Mock.new
    http.expect(:request, request_response, [request])

    Net::HTTP.stub(:get_response, landing_response) do
      Net::HTTP.stub(:start, ->(*, **, &block) { block.call(http) }) do
        Net::HTTP::Post.stub(:new, request) do
          assert_same request_response, job.send(:submit, 2025)
        end
      end
    end

    request.verify
    http.verify
  end

  test "submit params match current jma contract" do
    travel_to Time.zone.local(2026, 3, 23, 9, 0, 0) do
      params = ImportJmaJob.new.send(:submit_params, 2025)

      assert_equal "1", params["interAnnualType"]
      assert_nil params["interAnnualFlag"]
      assert_nil params["PHPSESSID"]
      assert_equal "[\"2025\",\"2025\",\"1\",\"12\",\"1\",\"31\"]", params["ymdList"]
    end
  end

  test "submit params limit current year to yesterday" do
    travel_to Time.zone.local(2026, 3, 23, 9, 0, 0) do
      params = ImportJmaJob.new.send(:submit_params, 2026)

      assert_equal "[\"2026\",\"2026\",\"1\",\"3\",\"1\",\"22\"]", params["ymdList"]
    end
  end

  private

  def fake_response(success:, cookies: nil)
    Object.new.tap do |response|
      response.define_singleton_method(:is_a?) do |klass|
        success && klass == Net::HTTPSuccess
      end

      response.define_singleton_method(:get_fields) do |name|
        name == "set-cookie" ? cookies : nil
      end
    end
  end
end
