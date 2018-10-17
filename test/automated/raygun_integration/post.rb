require_relative '../automated_init'

context "Post Error Data to the Raygun API" do
  test "Results in HTTP Status of 202 Accepted" do
    data = Controls::Data.example
    response = RaygunClient::HTTP::Post.(data)

    comment "Response code: #{response.code}"

    assert(response.code == '202')
  end
end
