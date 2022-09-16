# tl - a google translate cli

## Synopsis

```console
$ tl [-dh] [-f FROM] [-t TO] TEXT
```

## Description

`tl` is a minimalistic cli interface for google translate written in about 85 lines ofpure POSIX shell code, designed to be scriptable and composable, as a cli util should.
It translates the `TEXT` from language `FROM` to language `TO`, specified as ISO language code.

`tl` is inspired by [Simple Translate]() web extension and by default translates `TEXT` according to 2 environment variables:

`TL_PRIMARY_TARGET_LANGUAGE`: the default `TO` language. If unset defaults to `en`.
`TL_SECONDARY_TARGET_LANGUAGE`: the default `TO` language if the `FROM` language is detected to be same as `TL_PRIMARY_TARGET_LANGUAGE` by the API. If unset defaults to `fr`.

Therefore, by default running `tl bonjour` or `tl hallo` will output translation in english (`en`) as `FROM` language is detected to be `fr` and `de` accordingly, but `tl hello`, will output translation in french (`fr`), because it is detected to already be in `TL_PRIMARY_TARGET_LANGUAGE` (`en`), so `TL_SECONDARY_TARGET_LANGUAGE` is used.

The output format of `tl` is one of the following:
1. When the argument is a sentence or a long text, print the translation.
2. When the argument is a single word or a common phrase, print the following columns:
`SPEECH_PART TRANSLATION_VARIANT REVERSE_TRANSLATIONS`
where `SPEECH_PART` is speech part of translation variant of this row, `TRANSLATION_VARIANT` is a variant of a translation to the target language of the row, and `REVERSE_TRANSLATIONS` is a comma-separated list of reverse translations of that translation variant.

## Options

```console
 -f FROM    source language [DEFAULT: auto (autodetected by the API)]
 -t TO      target language [DEFAULT: ${TL_PRIMARY_TARGET_LANGUAGE}]
 -h         show this message and exit
 -d         enable debug mode (run `set -x`)
```

## Examples

Translate a sentence:
```console
$ tl Hello World!
Bonjour le monde!
```

Translate a single word:
```console
$ tl Hello
interjection  Bonjour!  Hello!,Hi!,Good morning!,Good afternoon!,How do you do?,Hallo!
interjection  Salut!    Hi!,Hello!,Salute!,All the best!,Hallo!,Hullo!
interjection  Tiens!    Hallo!,Hello!,Hullo!,Why!
interjection  Allô!     Hello!,Hullo!,Hallo!
```
```console
$ tl program
noun  programme        program,agenda,schedule,scheme,project,syllabus
noun  émission         emission,issuance,transmission,program,broadcast,broadcasting
noun  chaîne           chain,string,line,warp,range,program
noun  emploi du temps  program,programme
noun  poste            position,post,station,job,mail,program
verb  programmer       program,encode,programme
```

Translate to a specific language:
```console
tl -t de program # Translate to German
noun  Programm          program,scheme,channel,plan,agenda,schedule
noun  Sendung           broadcast,program,consignment,shipment,mission,broadcasting
noun  Plan              plan,schedule,map,scheme,design,plot
noun  Konzept           concept,plan,program,draft,notes,rough copy
noun  Fernsehprogramm   program,channel,TV guide,program guide,station,programme
verb  programmieren     program,programme
verb  planen            plan,schedule,design,organize,plot,program
verb  vorprogrammieren  program,programme
```
