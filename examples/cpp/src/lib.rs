use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use tokenizers::Tokenizer;

pub struct TokenizerWrapper(pub Tokenizer);

#[no_mangle]
pub extern "C" fn tokenizers_load_from_file(path: *const c_char) -> *mut TokenizerWrapper {
    if path.is_null() {
        return std::ptr::null_mut();
    }
    let c_str = unsafe { CStr::from_ptr(path) };
    match Tokenizer::from_file(c_str.to_str().unwrap()) {
        Ok(tok) => Box::into_raw(Box::new(TokenizerWrapper(tok))),
        Err(_) => std::ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn tokenizers_free(tokenizer: *mut TokenizerWrapper) {
    if tokenizer.is_null() {
        return;
    }
    unsafe { drop(Box::from_raw(tokenizer)); }
}

#[no_mangle]
pub extern "C" fn tokenizers_encode(tokenizer: *mut TokenizerWrapper, text: *const c_char) -> *mut c_char {
    if tokenizer.is_null() || text.is_null() {
        return std::ptr::null_mut();
    }
    let tok = unsafe { &mut *tokenizer };
    let text_str = unsafe { CStr::from_ptr(text).to_string_lossy().into_owned() };
    match tok.0.encode(text_str, true) {
        Ok(encoding) => {
            let tokens = encoding.get_tokens().join(" ");
            CString::new(tokens).unwrap().into_raw()
        }
        Err(_) => std::ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn tokenizers_decode(
    tokenizer: *mut TokenizerWrapper,
    ids: *const u32,
    len: usize,
    skip_special: bool,
) -> *mut c_char {
    if tokenizer.is_null() || ids.is_null() {
        return std::ptr::null_mut();
    }
    let tok = unsafe { &mut *tokenizer };
    let slice = unsafe { std::slice::from_raw_parts(ids, len) };
    match tok.0.decode(slice, skip_special) {
        Ok(text) => CString::new(text).unwrap().into_raw(),
        Err(_) => std::ptr::null_mut(),
    }
}

#[no_mangle]
pub extern "C" fn tokenizers_free_string(s: *mut c_char) {
    if s.is_null() {
        return;
    }
    unsafe {
        drop(CString::from_raw(s));
    }
}
