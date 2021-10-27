require 'test_helper'

class GeneratePdfsControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get generate_pdfs_top_url
    assert_response :success
  end

  test "should get result" do
    get generate_pdfs_result_url
    assert_response :success
  end

end
