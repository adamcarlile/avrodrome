RSpec.describe Avrodrome::Schema do
  let(:name) { Faker::Science.element.downcase.gsub(" ", "_") }
  let(:version) { Faker::Number.between(1, 100) }
  let(:id)   { Faker::Number.between(1, 100) }
  let(:fields) { [{ name: 'state', type: [nil, "string"], default: nil }] }
  let(:body) { { type: "record", name: name, fields: fields }.to_json }
  let(:arguments) do 
    { 
      body: body, 
      id: id, 
      version: version, 
      name: name 
    } 
  end
  let(:schema) { Avrodrome::Schema.new(arguments) }

  context "to_hash" do
    subject { schema.to_hash }

    it { expect(subject[:version]).to eql(version) }
    it { expect(subject[:id]).to eql(id) }
    it { expect(subject[:subject]).to eql(name) }
    it { expect(subject[:schema]).to eql(body) }
  end

  context "to_json" do
    subject {schema.to_json}

    it { expect(subject.to_json).to be_a(String) }
  end

end
