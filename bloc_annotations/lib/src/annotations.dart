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

/// Specifies a class that will be converted to a BLoC.
class BLoC {
  const BLoC();
}

/// Specifies a BLoC class member is an input stream.
class BLoCInput {
  const BLoCInput();
}

/// Specifies a BLoC class member is an output stream.
class BLoCOutput {
  const BLoCOutput();
}

/// Specifies a BLoC class member will store the last value of an output stream
/// called [outputName].
class BLoCValue {
  /// Name of the output stream that will update this value.
  final String outputName;

  const BLoCValue(this.outputName) : assert(outputName != null);
}

/// A parameter that will need to be added to the BLoC class and provided to the
/// BLoC either directly or through a provider or disposer. The parameter will
/// be passed to the constructor of the BLoC with a nameed parameter of [name].
class BLoCParameter {
  /// Type the provided parameter must be.
  final Type type;

  /// Name to give the parameter when passed to the constructor.
  final String name;

  const BLoCParameter(this.type, this.name);
}

/// Copies a template memeber to the generated BLoC.
class BLoCExport {
  const BLoCExport();
}

/// Specifies a BLoC class member that will be called when data is added to the
/// [inputName] stream. The return value will be added to the [outputName]
/// stream.
class BLoCMapper {
  /// The input stream to connect the mapper to.
  final String inputName;

  /// The output stream to connect the mapper to.
  final String outputName;

  const BLoCMapper(this.inputName, this.outputName)
      : assert(inputName != null),
        assert(outputName != null);
}

/// Automatically generates a mapper to connect [inputName] to [outputName] by
/// passing all inputs to the output.
class BLoCAutoMapper {
  /// The input stream to connect the mapper to.
  final String inputName;

  /// The output stream to connect the mapper to.
  final String outputName;

  const BLoCAutoMapper(this.inputName, this.outputName)
      : assert(inputName != null),
        assert(outputName != null);
}

class BLoCRequireService {
  /// The service type the service extends.
  final Type type;

  /// The controller to connect to for when [type] is InputService,
  /// OutputService or MapperService.
  final String controllerName;

  /// The second controller to connect to for when [type] is MapperService.
  final String secondaryControllerName;

  const BLoCRequireService(this.type,
      [this.controllerName, this.secondaryControllerName])
      : assert(type != null);
}
