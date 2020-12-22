RSpec.describe RubyObjectWithRust do
  it "has a version number" do
    expect(RubyObjectWithRust::VERSION).not_to be nil
  end

  describe '.create_user' do
    it do
      u = RubyObjectWithRust.create_user(2)
      RubyObjectWithRust.set_name(u, 'piyo')
      display = RubyObjectWithRust.get_display(u)
      expect(display).to eq('id: 2, name: piyo')
      RubyObjectWithRust.rust_free(u)
    end
  end
end
