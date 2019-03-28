describe FactoryBot::Tracker do
  subject { described_class.new }

  it "initializes with empty hash" do
    expect(subject.results).to eq({})
  end

  it "calls ActiveSupport::Notifications class" do
    class_name = subject.init.class.name
    expect(class_name).to match(/ActiveSupport::Notifications/)
  end
end
