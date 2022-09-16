# Reverse-engeneered schema of a google translate api response

Written in typescript, because i'm familiar with it.
Note: This schema is not full, only including the parts that matter for the `tl`.

```typescript
type Sentence = {
  trans: string,
  orig: string,
}

type DictEntry = {
  /// The dictionary translation variant - word or phrase describing original word
  word: 'string',
  /// Reverse translations for this translation variant in plain strings
  reverse_translation: string[],
  /// Commonality of this translation
  score: number,
}

type SpeechPart = {
  /// The speech part of this translation
  pos: 'noun' | 'verb' | 'adjective' | 'adverb',
  /// All of the translations in plain strings
  terms: string[],
  /// All of the translation in detailed objects
  entry: DictEntry[],
  /// Base/default form of the word
  base_form: string,
  /// Order of significance of this usage case as opposed 
  /// to other speech parts in the `dict` array of TranslationResponse.
  pos_enum: number,
}

type TranslationResponse = {
  /// Translation split up by sentences
  sentences: Sentence[],
  /// Translation variants, given when you query a single word or phrase
  dict?: SpeechPart[],
  /// Detected source iso-639-1 language code
  src: string,
  /// Confidence that source language detected correctly
  confidence: number,
}
```
