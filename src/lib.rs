mod user;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use user::User;

// ユーザーを初期化する関数。
// FFI経由でポインタをRuby側に渡すことになるので`*mut User`型の返り値が必要になる。
// `Box::new`でスマートポインタを得た上で、`Box::into_raw`で生ポインタを作っている。
#[no_mangle]
pub extern "C" fn create_user(id: u64) -> *mut User {
    return Box::into_raw(Box::new(User {
        id,
        name: String::new(),
    }));
}

// Userのidを取得する関数。
// create_userでRuby側に渡したUserのポインタをここで受け取って処理することになる。
// 生ポインタを操作する処理なので、`unsafe`を使う必要がある。
#[no_mangle]
pub unsafe extern "C" fn get_id(user: *mut User) -> u64 {
    let u: &mut User = &mut *user;
    return u.id;
}

// Userのnameを更新する関数。
// Ruby側から文字列を受け取るには`*const c_char`型を使う。
// ポインタからStringを生成してnameにセットしている。
// 今回は変換に失敗することが無いとして`unwrap()`を用いているが、状況に応じて要エラーハンドリング。
#[no_mangle]
pub unsafe extern "C" fn set_name(user: *mut User, name: *const c_char) {
    let u: &mut User = &mut *user;
    u.name = CStr::from_ptr(name).to_str().unwrap().to_string();
}

// Userのget_displayメソッドを呼んで得られた文字列を返す関数。
// set_name関数の引数で文字列を受け取ったのと同じく、文字列を返すときも`*const c_char`型を使う。
// CStringを生成してそのポインタを返している。
#[no_mangle]
pub unsafe extern "C" fn get_display(user: *mut User) -> *const c_char {
    let u: &mut User = &mut *user;
    let display = u.get_display();
    return CString::new(display).unwrap().into_raw();
}

// ポインタからメモリを開放する関数。
// ここまでの関数で、Userや文字列のポインタを外部に渡しているため
// 最終的にそれらを解放するために利用する。
#[no_mangle]
pub unsafe extern "C" fn release(c_ptr: *mut libc::c_void) {
    libc::free(c_ptr);
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::ffi::{CStr, CString};

    #[test]
    fn test_create_user() {
        unsafe {
            let u = create_user(3);
            assert_eq!(get_id(u), 3);
            assert_eq!(
                CStr::from_ptr(get_display(u)).to_str().unwrap(),
                "id: 3, name: "
            );
            set_name(u, CString::new("fuga").unwrap().into_raw());
            assert_eq!(
                CStr::from_ptr(get_display(u)).to_str().unwrap(),
                "id: 3, name: fuga"
            );
            release(u as *mut libc::c_void);
        }
    }
}
