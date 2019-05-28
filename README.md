# bloc_generator

[![Build Status](https://api.cirrus-ci.com/github/CallumIddon/bloc_generator.svg)](https://cirrus-ci.com/github/CallumIddon/bloc_generator)

bloc_generator is a combination of three packages.

[bloc_annotations](https://github.com/CallumIddon/bloc_generator/tree/master/bloc_annotations)
contains the annotations and `Service` abstract classes for
annotating your apps code.

[bloc_generator](https://github.com/CallumIddon/bloc_generator/tree/master/bloc_generator)
uses the annotations to generate BLoCs for your app.

[flutter_bloc_provider](https://github.com/CallumIddon/bloc_generator/tree/master/flutter_bloc_provider)
contains flutter widgets for providing the BLoCs to Flutter apps.

Each package has its own documentation in its README and more extensive
documentation can be found on each class.

## How BLoCs Work

### Inputs and Outputs

Inputs and outputs must be a class with a `Stream` and `Sink` such as a
`StreamController`. These provide the communication to code outside the BLoC,
such as to a `StreamBuilder` widget.

### Mappers

Mappers bridge inputs and outputs by yielding any values that is to be added to
the output `Stream` while taking one input, the value that was added to the
input `Sink`.

### Parameters

Parameters are values that are passed to the BLoC when it is initialized. This
allows mappers and services to be able to change their behaviour based on the
provided parameters.

### Services

Services are automatically or manually triggered classes that can modify any
BLoC they connect to.

All services are notified when a BLoC is disposed through the optional
`dispose()` method.

#### Input Services

Input services connect to an input on a BLoC and are triggered when the BLoC is
initialized through the `init()` method.

#### Output Services

Output services connect to an output an a BLoC and are triggered when a new
value is added to that output through the `listen()` method. Optionally the
`init()` method can be used to be notified when a new BLoC is initialized.

#### BLoC Services

BLoC services are passed the entire bloc in the `init()` method and will have
access to the entire BLoC. Subscribing to inputs and outputs must be handled and
disposed of manually.

#### Trigger Services

Trigger services are manually by calling the `trigger()` method on the service.
The service can be provided with optional data.

#### Mapper Services

Mapper services act the same as normal mappers with the `map()` method. This
allows mappers to be reused and extended between BLoCs.

### Providers

A provider serves two functions. The first is as to make the BLoC accessible to
the widgets lower in the widget tree. The second is to retrieve that BLoC
from a `BuildContext` in widgets below the provider.

### Disposers

A disposer is a helper that is the same as a provider with the noteable
change of automatically disposing of the BLoC when it goes out of context. A
disposer also cannot retrieve BLoCs.

## Example

An example of how to use these packages is available in the
[example](https://github.com/CallumIddon/bloc_generator/tree/master/example)
directory.
