require "test_helper"

class TabletsControllerTest < ActionDispatch::IntegrationTest
  test "tablets statistics ルーティング" do
    assert_routing({ method: "get", path: "/tablets/statistics" }, { controller: "tablets/statistics", action: "index" })
    assert_routing({ method: "get", path: "/tablets/statistics/tab1" }, { controller: "tablets/statistics", action: "tab1" })
    assert_routing({ method: "get", path: "/tablets/statistics/tab2" }, { controller: "tablets/statistics", action: "tab2" })
    assert_routing({ method: "get", path: "/tablets/statistics/tab3" }, { controller: "tablets/statistics", action: "tab3" })
    assert_routing({ method: "get", path: "/tablets/statistics/tab4" }, { controller: "tablets/statistics", action: "tab4" })
    assert_routing({ method: "get", path: "/tablets/statistics/tab5" }, { controller: "tablets/statistics", action: "tab5" })
    assert_routing({ method: "get", path: "/tablets/statistics/tab6" }, { controller: "tablets/statistics", action: "tab6" })
  end
end
