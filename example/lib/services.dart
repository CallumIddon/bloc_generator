// Copyright 2019 Callum Iddon
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:bloc_annotations/bloc_annotations.dart';

import 'package:flutter_bloc_example/bloc.dart';

class SetService extends InputService<int> {
  @override
  Future<void> init(final Sink<int> sink) async {
    await Future<void>.delayed(Duration(seconds: 5));
    sink.add(10);
  }
}

class PrintService extends OutputService<String> {
  @override
  void listen(final String data) {
    print('Counter set to: $data');
  }
}

class MaxService extends BLoCService<TestBLoC> {
  StreamSubscription<String> _counterSub;

  @override
  void init(final TestBLoC bloc) {
    _counterSub = bloc.counter.listen((final String counter) {
      if (int.parse(counter) >= bloc.maxValue) {
        print('Looks like you hit ${bloc.maxValue}');
        print('Resetting...');
        bloc.setCounter.add(0);
      }
    });
  }

  @override
  void dispose() {
    _counterSub.cancel();
  }
}

class UrlService extends TriggerService<void> {
  @override
  void trigger([final void data]) {
    print('https://github.com/CallumIddon/bloc_generator');
  }
}

class StringifyMapper extends MapperService<int, String> {
  @override
  Stream<String> map(final int inputData) async* {
    yield inputData.toString();
  }
}
