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

import 'package:flutter/material.dart';

import 'package:flutter_bloc_provider/flutter_bloc_provider.dart';

import 'package:flutter_bloc_example/bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BLoCDisposer<TestBLoC>(
        bloc: TestBLoC(maxValue: 20),
        child: const MyHomePage(title: 'Flutter bloc_generator Demo'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({this.title});

  @override
  Widget build(final BuildContext context) {
    final TestBLoC bloc = BLoCProvider.of<TestBLoC>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            StreamBuilder<String>(
              stream: bloc.counter,
              builder: (final BuildContext context,
                  final AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                return Column(children: <Widget>[
                  Text(
                    snapshot.data,
                    style: Theme.of(context).textTheme.display1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        child: const Text('Reset Counter'),
                        onPressed: () => bloc.setCounter.add(0),
                      ),
                      MaterialButton(
                        child: const Text('Trigger Url Service'),
                        onPressed: () {
                          if (int.parse(bloc.currentCounter) != 0) {
                            bloc.urlService.trigger();
                          } else {
                            print('Hit the + button first.');
                          }
                        },
                      ),
                    ],
                  ),
                ]);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.addToCounter.add(1),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
