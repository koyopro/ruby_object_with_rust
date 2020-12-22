require "ruby_object_with_rust/version"
require 'ffi'

module RubyObjectWithRust
  extend FFI::Library
  # MacOS or Linux
  ext = `uname` =~ /Darwin/ ? 'dylib' : 'so'
  ffi_lib File.join(__dir__, '..', "target/release/libruby_object_with_rust.#{ext}")

  class Error < StandardError; end

  attach_function :create_user, :create_user, [:int], :pointer
  attach_function :set_name, [:pointer, :string], :void
  attach_function :get_display, [:pointer], :string
  attach_function :rust_free, [:pointer], :void
end
