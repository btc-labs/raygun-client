require_relative 'automated_init'

context "Data Equality" do
  test "Data object equality can be tested" do
    data_1 = Controls::Data.example
    data_2 = Controls::Data.example

    assert(data_1 == data_2)
  end
end
