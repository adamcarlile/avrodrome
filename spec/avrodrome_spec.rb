RSpec.describe Avrodrome do
  it "has a version number" do
    expect(Avrodrome.version).not_to be nil
  end

  context "configuration" do
    subject { Avrodrome.config }
    around(:each) do |example|
      old_config = Avrodrome.config.dup
      example.run
      Avrodrome.instance_variable_set(:@config, old_config)
    end


    context "able to configure a logger"
      let(:log) { Logger.new(STDOUT) }

      before do
        Avrodrome.configure do |config|
          config.logger = log
        end
      end

      it { expect(subject.logger).to eql(log) }
  end
end
