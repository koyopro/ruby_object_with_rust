mod user;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use user::User;

#[no_mangle]
pub unsafe extern "C" fn create_user(id: u64) -> *mut User {
    return Box::into_raw(Box::new(User {
        id,
        name: String::new(),
    }));
}

#[no_mangle]
pub unsafe extern "C" fn get_id(user: *mut User) -> u64 {
    let u: &mut User = &mut *user;
    return u.id;
}

#[no_mangle]
pub unsafe extern "C" fn set_name(user: *mut User, name: *const c_char) {
    let u: &mut User = &mut *user;
    u.name = CStr::from_ptr(name).to_str().unwrap().to_string();
}

#[no_mangle]
pub unsafe extern "C" fn get_display(user: *mut User) -> *const c_char {
    let u: &mut User = &mut *user;
    let display = u.get_display();
    return CString::new(display).unwrap().into_raw();
}

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
