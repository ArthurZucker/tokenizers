#ifndef TOKENIZERS_CPP_H
#define TOKENIZERS_CPP_H


#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct TokenizerWrapper TokenizerWrapper;

TokenizerWrapper* tokenizers_load_from_file(const char* path);
void tokenizers_free(TokenizerWrapper* tokenizer);
char* tokenizers_encode(TokenizerWrapper* tokenizer, const char* text);
char* tokenizers_decode(TokenizerWrapper* tokenizer, const uint32_t* ids, size_t len, bool skip_special_tokens);
void tokenizers_free_string(char* s);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // TOKENIZERS_CPP_H
