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

    def id
      RubyObjectWithRust.get_id(self)
    end

    def name=(new_value)
      RubyObjectWithRust.set_name(self, new_value)
    end

    def display
      result, ptr = RubyObjectWithRust.get_display(self)
      RubyObjectWithRust::AutoPointer.new(ptr)
      result
    end

    def self.release(ptr)
      RubyObjectWithRust.release(ptr)
    end
  end
end
