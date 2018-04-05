require_relative '../automated_init'

context "Error Data Deserialization" do
  test "Converts from JSON text" do
    compare_error_data = ErrorData::Controls::ErrorData.example

    json_text = ErrorData::Controls::ErrorData::JSON.text

    error_data = Transform::Read.(json_text, :json, compare_error_data.class)

    assert(error_data == compare_error_data)
  end
end
