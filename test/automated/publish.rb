require_relative './automated_init'

context "Publish" do
  error = Controls::Error.example

  response = RaygunClient::Publish.(error, tag: 'some-tag')

  test "Response indicates success" do
    assert(Net::HTTPAccepted === response)
  end
end
