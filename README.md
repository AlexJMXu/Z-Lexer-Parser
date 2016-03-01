# Lexer and Parser for Z

## Implementation decisions
* In the Z specification language, top was defined in seq/dict but was not mentioned whether or not it could be used as a normal assignment (e.g. top a = 5;), so we assumed that it was possible to assign as a top type.
* For a newly defined type that has an empty list of declation fields, to instantiate it we assume the following syntax to be valid:

```
tdef person {};
person foo = ; //Equals sign immediately followed by semicolon
```

## Building
To build, issue `make`.


## Testing
To test, issue `make test`.

## Credits
* Alex Xu
* Galen Han
* Jamie Law