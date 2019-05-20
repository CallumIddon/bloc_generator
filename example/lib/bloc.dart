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

import 'package:rxdart/rxdart.dart';

import 'package:bloc_annotations/bloc_annotations.dart';

import 'package:flutter_bloc_example/services.dart';

part 'bloc.bloc.dart';

@BLoC()
@BLoCParameter(int, 'maxValue')
@BLoCRequireInputService(SetService, 'setCounter')
@BLoCRequireOutputService(PrintService, 'counter')
@BLoCRequireBLoCService(MaxService)
@BLoCRequireTriggerService(UrlService)
@BLoCRequireMapperService(StringifyMapper, 'setCounter', 'counter')
class _Test extends BLoCTemplate {
  @BLoCExportMember()
  int maxValue;

  _Test({this.maxValue});

  @BLoCInput()
  StreamController<int> setCounter = StreamController<int>();
  @BLoCInput()
  StreamController<int> addToCounter = StreamController<int>();

  @BLoCOutput()
  BehaviorSubject<String> counter = BehaviorSubject<String>(seedValue: '0');

  @BLoCValue('counter')
  String currentCounter;

  @BLoCMapper('addToCounter', 'counter')
  Stream<String> setAddToCounterBLoC(final int inputData) async* {
    yield (int.parse(currentCounter) + inputData).toString();
  }
}
