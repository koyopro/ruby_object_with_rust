RSpec.describe RubyObjectWithRust::User do
  let(:user) { described_class.new(4) }

  before { user.name = 'piyo'}

  describe '#id' do
    it { expect(user.id).to eq(4) }
  end

  describe '#display' do
    it { expect(user.display).to eq('id: 4, name: piyo') }
  end
end
