import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

typedef _LoadFunc = ffi.Pointer<TokenizersTokenizer> Function(ffi.Pointer<ffi.Utf8>);
typedef _EncodeFunc = ffi.Pointer<ffi.Char> Function(ffi.Pointer<TokenizersTokenizer>, ffi.Pointer<ffi.Utf8>);
typedef _DecodeFunc = ffi.Pointer<ffi.Char> Function(ffi.Pointer<TokenizersTokenizer>, ffi.Pointer<ffi.Uint32>, int, ffi.Uint8);
typedef _FreeTokenizer = ffi.Void Function(ffi.Pointer<TokenizersTokenizer>);
typedef _FreeString = ffi.Void Function(ffi.Pointer<ffi.Char>);

class TokenizersTokenizer extends ffi.Opaque {}

class TokenizersBinding {
  late final ffi.DynamicLibrary _lib;
  late final _LoadFunc _load;
  late final _EncodeFunc _encode;
  late final _DecodeFunc _decode;
  late final _FreeTokenizer _freeTokenizer;
  late final _FreeString _freeString;

  TokenizersBinding(String libPath) {
    _lib = ffi.DynamicLibrary.open(libPath);
    _load = _lib.lookupFunction<_LoadFunc, _LoadFunc>('tokenizers_load_from_file');
    _encode = _lib.lookupFunction<_EncodeFunc, _EncodeFunc>('tokenizers_encode');
    _decode = _lib.lookupFunction<_DecodeFunc, _DecodeFunc>('tokenizers_decode');
    _freeTokenizer = _lib.lookupFunction<_FreeTokenizer, _FreeTokenizer>('tokenizers_free');
    _freeString = _lib.lookupFunction<_FreeString, _FreeString>('tokenizers_free_string');
  }

  ffi.Pointer<TokenizersTokenizer> loadFromFile(String path) {
    return _load(path.toNativeUtf8());
  }

  String encode(ffi.Pointer<TokenizersTokenizer> tokenizer, String text) {
    final resultPtr = _encode(tokenizer, text.toNativeUtf8());
    final result = resultPtr.cast<ffi.Utf8>().toDartString();
    _freeString(resultPtr);
    return result;
  }

  String decode(ffi.Pointer<TokenizersTokenizer> tokenizer, List<int> ids, {bool skipSpecialTokens = true}) {
    final ptr = calloc<ffi.Uint32>(ids.length);
    for (var i = 0; i < ids.length; i++) {
      ptr[i] = ids[i];
    }
    final resultPtr = _decode(tokenizer, ptr, ids.length, skipSpecialTokens ? 1 : 0);
    calloc.free(ptr);
    final result = resultPtr.cast<ffi.Utf8>().toDartString();
    _freeString(resultPtr);
    return result;
  }

  void freeTokenizer(ffi.Pointer<TokenizersTokenizer> tokenizer) {
    _freeTokenizer(tokenizer);
  }
}
