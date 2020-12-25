module RubyObjectWithRust
  #
  # Userクラス
  #
  # FFI::ManagedStructを継承する
  class User < FFI::ManagedStruct
    layout :user, :pointer

    # このクラスの各メソッドではRubyObjectWithRustモジュールで定義したメソッドを使う

    # 以下で定義したメソッドを利用してstruct Userのポインタを取得
    #   attach_function :create_user, :create_user, [:int], :pointer
    # super (= FFI::ManagedStruct.new ) には得られたポインタを渡す
    def self.new(id)
      super(RubyObjectWithRust.create_user(id))
    end

    # 以下で定義したメソッドを利用してidを取得
    #   attach_function :get_id, [User], :int
    # 引数にUserを指定しているので、selfを渡している
    def id
      RubyObjectWithRust.get_id(self)
    end

    # 以下で定義したメソッドを利用してnameを設定
    #   attach_function :set_name, [User, :string], :void
    # new_valueはRubyの文字列で、:stringタイプとしてそのまま渡せる
    def name=(new_value)
      RubyObjectWithRust.set_name(self, new_value)
    end

    # 以下で定義したメソッドを利用して文字列を取得
    #   attach_function :get_display, [User], :strptr
    #   Rust側の返り値が文字列のポインタなので、:strptrタイプを使う
    # resultには文字列、ptrにはポインタが渡ってくる
    # AutoPointerを使って、文字列の利用が終わったらGCで処理されるようにしている
    def display
      result, ptr = RubyObjectWithRust.get_display(self)
      RubyObjectWithRust::AutoPointer.new(ptr)
      result
    end

    # UserクラスのインスタンスがGCで開放される際に実行される
    # 以下で定義したメソッドを利用してメモリを開放する
    #   attach_function :release, [:pointer], :void
    def self.release(ptr)
      RubyObjectWithRust.release(ptr)
    end
  end
end
