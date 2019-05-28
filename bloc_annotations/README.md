# bloc_annotations

This package is part of a number of packages designed to help create BLoC
architected code in Dart and Flutter. You can view them all in the repository
[here](https://github.com/CallumIddon/bloc_generator).

This README relies on the fact that you have read the main
[README](https://github.com/CallumIddon/bloc_generator/tree/master/README.md).

## Installation

```yaml
dependencies:
  bloc_annotations: <latest_version>
```

## Input Class

All the annotated members of your BLoC class that have annotations must be
public as the generated code uses them. Members without annotations can still be
used normally such as in `@BLoCMapper` methods. `@BLoCValue`s initial data will
will be added to the stream once all service have been initialized.

### Different Controllers

Using `StreamController` isn't required so `rxdart`s `subject`s such as
`BehaviourSubject` can be used as shown in the
[example](https://github.com/CallumIddon/bloc_generator/tree/master/example/lib/bloc.dart#L54).

## Output Class

The output class can be seen in the generated `.bloc.dart` file. The BLoCs name
will be the same as the template class with the suffix of `BLoC`.

## Importing the Output Class

The generated `.bloc.dart` file uses a `part of` statment, so your template file
must contain a `part` statement.
