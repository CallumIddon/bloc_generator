# flutter_bloc_provider

This package is part of a number of packages designed to help create BLoC
architected code in Dart and Flutter. You can view them all in the repository
[here](https://github.com/CallumIddon/bloc_generator).

This README relies on the fact that you have read the main
[README](https://github.com/CallumIddon/bloc_generator/tree/master/README.md).

## Installation

```yaml
dependencies:
  flutter_bloc_provider: <latest_version>
```

## Provider

A `BLoCProvider<BLoC>` is an `InheritedWidget` that allows the `BLoC` to be
accessible to sub widgets. Calling `BLoCProvider<BLoC>.of(context)` will return
the `BLoC` from the tree.

Make sure you call the `dispose` method of the `BLoCProvider` when you are done
with it to close any open streams and stop any services.

## Disposer

A `BLoCDisposer<BLoC>` is a `StatefulWidget` that wraps a child in a
`BLoCProvider`. The disposer will automatically call the dispose method on the
provider when it loses context.

## Multi Providers and Disposers

The `BLoCMultiProvider` and `BLoCMultiDisposer` allow multiple BLoCs to be added
to the widget tree at once and behave exactly as their singular counterparts.
