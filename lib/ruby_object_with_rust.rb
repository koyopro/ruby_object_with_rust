require 'ffi'
require "ruby_object_with_rust/version"
require 'ruby_object_with_rust/user'

module RubyObjectWithRust
  extend FFI::Library
  # MacOS or Linux
  ext = `uname` =~ /Darwin/ ? 'dylib' : 'so'
  ffi_lib File.join(__dir__, '..', "target/release/libruby_object_with_rust.#{ext}")

  class AutoPointer < FFI::AutoPointer
    def self.release(ptr)
      RubyObjectWithRust.release(ptr)
    end
  end

  class Error < StandardError; end

  attach_function :create_user, :create_user, [:int], :pointer
  attach_function :get_id, [User], :int
  attach_function :set_name, [User, :string], :void
  attach_function :get_display, [User], :strptr
  attach_function :release, [:pointer], :void
end
