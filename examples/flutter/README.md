# Flutter bindings for tokenizers

This package provides basic FFI access to the C API defined in `../cpp`.
It can be used to load a tokenizer and encode or decode text on mobile or desktop Flutter apps.

Example usage:
```dart
final binding = TokenizersBinding('libtokenizers.so');
final tok = binding.loadFromFile('tokenizer.json');
final output = binding.encode(tok, 'Hello world');
print(output);
final decoded = binding.decode(tok, [101, 102, 103]);
print(decoded);
```
