RSpec.describe RubyObjectWithRust::User do
  let(:user) { described_class.new(4) }

  before { u.name = 'piyo'}

  it { expect(u.display).to eq('id: 4, name: piyo') }
end
