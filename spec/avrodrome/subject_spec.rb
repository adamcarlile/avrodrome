RSpec.describe Avrodrome::Subject do
  let(:name)   { Faker::Science.element.downcase.gsub(" ", "_") }
  let(:fields) { [{ name: 'state', type: [nil, "string"], default: nil }] }
  let(:schema) { { type: "record", name: name, fields: fields }.to_json }
  
  let(:avro_subject) { Avrodrome::Subject.new(name: name) }

  context "registering a schema" do
    let(:id)      { Faker::Number.between(from: 1, to: 100) }
    let(:version) { Faker::Number.between(from: 1, to: 100) }

    before do 
      avro_subject.register!(schema: schema, id: id, version: version)
    end

    it { expect(avro_subject.schemas.count).to eql(1) }
    it { expect(avro_subject.schemas.last.id).to eql(id) }
    it { expect(avro_subject.schemas.last.version).to eql(version) }

    context "finding a schema" do
      it { expect(avro_subject.find(id).id).to eql(id) }
    end

    context "find by version" do
      it { expect(avro_subject.version(version).version).to eql(version) }
    end

    context "find by version with no args (AKA latest version)" do
      it { expect(avro_subject.version.version).to eql(version) }
    end

    context "total schemas count" do
      it { expect(avro_subject.total_schemas).to eql(1) }
    end

  end
end
