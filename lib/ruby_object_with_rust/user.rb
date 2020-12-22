require 'ffi'

module RubyObjectWithRust
  #
  # Userクラス
  #
  class User < FFI::ManagedStruct
    layout :user, :pointer

    def self.new(id)
      super(RubyObjectWithRust.create_user(id))
    end

    def name=(new_value)
      RubyObjectWithRust.set_name(self, new_value)
    end

    def display
      RubyObjectWithRust.get_display(self)
    end

    def self.release(ptr)
      RubyObjectWithRust.rust_free(ptr)
    end
  end
end
