require 'ffi'
require 'ruby_object_with_rust/user'

module RubyObjectWithRust
  extend FFI::Library
  # FFIを利用するために、`extend FFI::Library`したモジュールを用意する。
  # MacとLinuxではRustをビルドした時に生成されるバイナリの拡張子が異なるので、環境で分岐している。
  ext = `uname` =~ /Darwin/ ? 'dylib' : 'so'
  ffi_lib File.join(__dir__, '..', "target/release/libruby_object_with_rust.#{ext}")

  class AutoPointer < FFI::AutoPointer
    def self.release(ptr)
      RubyObjectWithRust.release(ptr)
    end
  end

  class Error < StandardError; end

  # FFIの機能でRubyのメソッドとRust側で用意したインターフェースを紐付けている。
  # 引数は<Ruby側メソッド名, Rust側関数名, 引数の型の配列, 返り値の型>の4つ
  # (メソッド名と関数名が一致する場合は一つだけ書けば良い)
  # Userを指定している部分は`:pointer`でも動作する。
  attach_function :create_user, :create_user, [:int], :pointer
  attach_function :get_id, [User], :int
  attach_function :set_name, [User, :string], :void
  attach_function :get_display, [User], :strptr
  attach_function :release, [:pointer], :void
end
