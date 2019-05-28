# Changelog

## 0.6.0

* Require services to be initialized by the template
* Allow BLoCValue to have initial data
* Replace individual service require with generic
* Move BLoCParamater to the constructor
* Overhaul bloc_generator

## 0.5.1

* Add BLoCMultiProvider and BLoCMultiDisposer

## 0.5.0

* Add Documentation
* Refactor
* Format
* Add CI
* Make parameters private by default

## 0.4.4

* Changed name from flutter_bloc_generator to bloc_generator

## 0.3.0

* Removed AsyncMapperService
* Made all mappers streams
* Split out providers and disposer to flutter_bloc_provider package

## 0.2.6

* Add MapperService, AsyncMapperService, RequireMapperService and
RequireAsyncMapperService

## 0.2.5

* Currect trigger types to Future\<void\> from void
* Make mappers optionally async

## 0.2.4

* Add TriggeredService

## 0.2.3

* Allow mappers to return null to not add anything to the output

## 0.2.2

* Added parameters that can be passed to the BLoC and are accessible to BLoC
services

## 0.2.1

* Make requiring a service require the service type
* Add BLoCService service that takes an entire BLoC instead of a Stream or Sink

## 0.2.0

* Make mappers async

## 0.1.9

* Make template value the only current value stored

## 0.1.8

* Moved value updater before calling mappers
* Updating latest values on template

## 0.1.7

* OutputService automatic listener
* OutputService automatic subscription disposer

## 0.1.6

* Remove current data from mappers

## 0.1.5

* Made services public members

## 0.1.4

* Changed Service to InputService and added OutputService

## 0.1.3

* Format code
* Add example

## 0.1.2

* Fix latest value updater for initial data

## 0.1.1

* Change analyzer dependency to ^0.33.0 for compatability

## 0.1.0

* Initial public release
