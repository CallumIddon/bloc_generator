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

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';

import 'package:meta/meta.dart';

class ServiceConnector {
  final String name;
  final DartType type;
  final DartType serviceType;
  final String controller;

  ServiceConnector(
      {@required this.name,
      @required this.type,
      @required this.serviceType,
      this.controller})
      : assert(name != null),
        assert(type != null),
        assert(serviceType != null);
}

class BLoCElementVisitor extends SimpleElementVisitor<void> {
  final Map<String, String> streams = <String, String>{};

  final Map<String, String> sinks = <String, String>{};

  final Map<String, DartType> controllers = <String, DartType>{};

  final Map<String, DartType> parameters = <String, DartType>{};

  // { input: { template: type } }
  final Map<String, Map<String, DartType>> values =
      <String, Map<String, DartType>>{};

  final Map<String, DartType> exports = <String, DartType>{};

  final List<ServiceConnector> services = <ServiceConnector>[];

  // { input: { function: output } }
  final Map<String, Map<String, String>> mappers =
      <String, Map<String, String>>{};

  @override
  void visitFieldElement(final FieldElement element) {
    for (final ElementAnnotation metadata in element.metadata) {
      final DartObject annotation = metadata.computeConstantValue();
      final ParameterizedType type = annotation.type;

      // TODO(CallumIddon): Don't use strings to compare DartType to Type.
      switch (type.name) {
        case 'BLoCInput':
          {
            String type = 'Sink';
            if (element.type.displayName.contains('<')) {
              type += element.type.displayName.substring(
                  element.type.displayName.indexOf('<'),
                  element.type.displayName.lastIndexOf('>') + 1);
            }
            sinks[element.name] = type;
            controllers[element.name] = element.type;
            break;
          }
        case 'BLoCOutput':
          {
            String type = 'Stream';
            if (element.type.displayName.contains('<')) {
              type += element.type.displayName.substring(
                  element.type.displayName.indexOf('<'),
                  element.type.displayName.lastIndexOf('>') + 1);
            }
            streams[element.name] = type;
            controllers[element.name] = element.type;
            break;
          }
        case 'BLoCValue':
          {
            final String outputName =
                annotation.getField('outputName').toStringValue();
            values[outputName] = (values[outputName] ?? <String, DartType>{})
              ..addAll(<String, DartType>{element.name: element.type});
            break;
          }
        case 'BLoCExport':
          {
            exports[element.name] = element.type;
            break;
          }
        case 'BLoCRequireService':
          {
            final DartType type = annotation.getField('type').toTypeValue();
            final String controllerName =
                annotation.getField('controllerName').toStringValue();

            // TODO(CallumIddon): Don't use strings to compare DartType to Type.
            if (type.name == 'MapperService') {
              mappers[controllerName] =
                  (mappers[controllerName] ?? <String, String>{})
                    ..addAll(<String, String>{
                      '${element.name}.map': annotation
                          .getField('secondaryControllerName')
                          .toStringValue(),
                    });
            }

            services.add(ServiceConnector(
              name: element.name,
              type: element.type,
              serviceType: type,
              controller: controllerName,
            ));
            break;
          }
      }
    }
  }

  @override
  void visitMethodElement(final MethodElement element) {
    for (final ElementAnnotation metadata in element.metadata) {
      final DartObject annotation = metadata.computeConstantValue();
      final ParameterizedType type = annotation.type;

      // TODO(CallumIddon): Don't use strings to compare DartType to Type.
      if (type.name == 'BLoCMapper') {
        final String inputName =
            annotation.getField('inputName').toStringValue();
        mappers[inputName] = (mappers[inputName] ?? <String, String>{})
          ..addAll(<String, String>{
            'template.${element.name}':
                annotation.getField('outputName').toStringValue(),
          });
      }
    }
  }

  @override
  void visitConstructorElement(final ConstructorElement element) {
    for (final ElementAnnotation metadata in element.metadata) {
      final DartObject annotation = metadata.computeConstantValue();
      final ParameterizedType type = annotation.type;

      // TODO(CallumIddon): Don't use strings to compare DartType to Type.
      if (type.name == 'BLoCParameter') {
        parameters[annotation.getField('name').toStringValue()] =
            annotation.getField('type').toTypeValue();
      }
    }
  }
}
