RSpec.describe RubyObjectWithRust::User do
  it do
    u = described_class.new(4)
    expect(u.display).to eq('id: 4, name: ')
    u.name = 'piyo'
    expect(u.display).to eq('id: 4, name: piyo')
  end
end
