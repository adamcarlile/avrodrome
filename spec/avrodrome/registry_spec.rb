RSpec.describe Avrodrome::Adaptor do
  let(:name)   { Faker::Science.element.downcase.gsub(" ", "_") }
  let(:fields) { [{ name: 'state', type: [nil, "string"], default: nil }] }
  let(:schema) { { type: "record", name: name, fields: fields }.to_json }

  subject { Avrodrome::Adaptor.new }

  context "#register" do
    it { expect(subject.register(name, schema)).to be_a Integer }
  end

  context "#fetch" do
    context "exists" do
      let(:id) { subject.register(name, schema) }
      it { expect(subject.fetch(id)).to eql(schema)}
    end
    
    context "doesnt exist" do
      it { expect(subject.fetch(123)[:error_code]).to eql(404) }
    end
  end

  context "#subjects" do
    let(:count) { 1 }
    before { count.times { subject.register(name, schema) } }

    it { expect(subject.subjects).to be_an(Array) }
    it { expect(subject.subjects.count).to eql(count) }

    context "same subject name" do
      let(:count) { 2 }
      let(:name)  { "event_name" }

      it { expect(subject.subjects.count).to eql(1) }
    end
  end

  context "#subject_versions" do
    before { subject.register(name, schema) }

    it { expect(subject.subject_versions(name)).to be_an(Array) }
    it { expect(subject.subject_versions(name).count).to eql(1) }
  end

  context "#subject_version" do
    let(:name)  { "event_name"}
    let(:count) { 2 }
    before { count.times { subject.register(name, schema) } }

    it { expect(subject.subject_version(name, count).version).to eql(count)}
  
    context "#subject_version('latest')" do
      it { expect(subject.subject_version(name, 'latest').version).to eql(count)}
    end

    context "missing version" do
      it { expect(subject.subject_version(name, 100)[:error_code]).to eql(40402) }
    end
  end

  context "#check" do
    before { subject.register(name, schema) }

    it { expect(subject.check(name, schema)).to be_a(Hash) }

    context "missing schema" do
      let(:new_fields) { [{ name: 'place', type: [nil, "string"], default: nil }] }
      let(:new_schema) { { type: "record", name: name, fields: new_fields }.to_json }
    
      it { expect(subject.check(name, new_schema)).to eql(nil) }
    end
  end
  
end
