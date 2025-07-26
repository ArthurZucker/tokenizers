# C++ bindings for tokenizers

This is a minimal C API exposing a few functions from the [tokenizers](../../tokenizers) crate.
It uses `cbindgen` to generate the header and produces a `cdylib` that can be linked from C or C++ programs.
The API allows loading a tokenizer, encoding text, decoding ids back to text, and freeing resources.

## Build

```
cargo build --release
```

The generated library will be available in `target/release`.

## Example

```c
#include "tokenizers.h"

int main() {
    TokenizerWrapper* tok = tokenizers_load_from_file("tokenizer.json");
    char* encoded = tokenizers_encode(tok, "Hello world");
    // ... use encoded
    uint32_t ids[] = {101, 102, 103};
    char* decoded = tokenizers_decode(tok, ids, 3, true);
    tokenizers_free_string(encoded);
    tokenizers_free_string(decoded);
    tokenizers_free(tok);
    return 0;
}
```
