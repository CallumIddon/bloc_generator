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

import 'package:bloc_annotations/bloc_annotations.dart';

import 'package:flutter_bloc_provider/src/provider.dart';

/// A StatefulWidget that wraps a [child] with a BLoCProvider<BLoCT> and will
/// automatically dispose of it when out of context.
class BLoCDisposer<BLoCT extends BLoCTemplate> extends StatefulWidget {
  /// A widget to wrap with the BLoCProvider<BLoCT>.
  final Widget child;

  /// The BLoC to make accessible to [child].
  final BLoCT bloc;

  const BLoCDisposer({@required this.child, @required this.bloc})
      : assert(child != null),
        assert(bloc != null);

  @override
  _BLoCDisposerState<BLoCT> createState() => _BLoCDisposerState<BLoCT>();
}

class _BLoCDisposerState<BLoCT extends BLoCTemplate>
    extends State<BLoCDisposer<BLoCT>> {
  @override
  void dispose() {
    super.dispose();
    widget.bloc.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BLoCProvider<BLoCT>(
      child: widget.child,
      bloc: widget.bloc,
    );
  }
}

class BLoCMultiDisposer extends StatefulWidget {
  final Widget child;

  final List<BLoCTemplate> blocs;

  const BLoCMultiDisposer({@required this.child, @required this.blocs})
      : assert(child != null),
        assert(blocs != null);

  @override
  _BLoCMultiDisposerState createState() => _BLoCMultiDisposerState();
}

class _BLoCMultiDisposerState extends State<BLoCMultiDisposer> {
  @override
  void dispose() {
    super.dispose();
    for (final BLoCTemplate bloc in widget.blocs) {
      bloc.dispose();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return BLoCMultiProvider(
      child: widget.child,
      blocs: widget.blocs,
    );
  }
}
