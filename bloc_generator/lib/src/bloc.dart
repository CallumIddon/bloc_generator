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

import 'package:build/build.dart';

import 'package:code_builder/code_builder.dart';

import 'package:source_gen/source_gen.dart';

import 'package:bloc_annotations/bloc_annotations.dart';

import 'package:bloc_generator/src/class_finder.dart';

class BLoCGenerator extends GeneratorForAnnotation<BLoC> {
  final BuilderOptions options;

  BLoCGenerator(this.options);

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final String name =
        '${element.name[0] == '_' ? element.name.substring(1) : element.name}'
        'BLoC';

    final Map<String, List<String>> autoMappers = <String, List<String>>{};

    for (final ElementAnnotation metadata in element.metadata) {
      final DartObject annotation = metadata.computeConstantValue();
      final ParameterizedType type = annotation.type;

      // TODO(CallumIddon): Don't use strings to compare DartType to Type.
      if (type.name == 'BLoCAutoMapper') {
        final String inputName =
            annotation.getField('inputName').toStringValue();
        autoMappers[inputName] = (autoMappers[inputName] ?? <String>[])
          ..add(annotation.getField('outputName').toStringValue());
      }
    }

    final BLoCElementVisitor visitor = BLoCElementVisitor();
    element.visitChildren(visitor);

    final StringBuffer initializerList = StringBuffer();
    for (final String name in visitor.parameters.keys) {
      initializerList.writeln('$name: $name,');
    }

    final StringBuffer mappers = StringBuffer();
    for (final String inputName in visitor.mappers.keys) {
      mappers.writeln('_$inputName.stream.listen((data) {');
      for (final String functionName in visitor.mappers[inputName].keys) {
        mappers.writeln('$functionName(data)'
            '.forEach(_${visitor.mappers[inputName][functionName]}.sink.add);');
      }
      mappers.writeln('});');
    }

    for (final String inputName in autoMappers.keys) {
      for (final String outputName in autoMappers[inputName]) {
        mappers.writeln('_$inputName.stream.listen(_$outputName.sink.add);');
      }
    }

    final StringBuffer values = StringBuffer();
    final StringBuffer valueInitializers = StringBuffer();
    for (final String controller in visitor.values.keys) {
      for (final String name in visitor.values[controller].keys) {
        values.writeln('_$controller.stream.listen((data) => '
            'template.$name = data);');
        valueInitializers.writeln('_$controller.sink.add(template.$name);');
      }
    }

    final StringBuffer serviceInitializers = StringBuffer();
    final StringBuffer serviceDisposers = StringBuffer();

    for (final ServiceConnector service in visitor.services) {
      switch (service.serviceType.name) {
        case 'InputService':
        case 'OutputService':
          {
            serviceInitializers
                .writeln('${service.name}.init(${service.controller});');
            break;
          }
        case 'TriggerService':
        case 'MapperService':
          {
            serviceInitializers.writeln('${service.name}.init();');
            break;
          }
        case 'BLoCService':
          {
            serviceInitializers.writeln('${service.name}.init(this);');
            break;
          }
      }
      serviceDisposers.writeln('${service.name}.dispose();');
    }

    final Class bloc = Class((final ClassBuilder builder) {
      builder
        ..name = name
        ..extend = const Reference('BLoCTemplate')
        ..fields.add(Field((final FieldBuilder builder) {
          builder
            ..name = 'template'
            ..type = Reference(element.name)
            ..modifier = FieldModifier.final$;
        }))
        ..methods.addAll(<Method>[
          Method((final MethodBuilder builder) {
            builder
              ..name = 'dispose'
              ..returns = const Reference('void')
              ..annotations.add(const Reference('override'))
              ..body = Code('''
                  template.dispose();

                  $serviceDisposers
                ''');
          }),
          for (final String controller in visitor.controllers.keys)
            Method((final MethodBuilder builder) {
              builder
                ..name = '_$controller'
                ..returns =
                    Reference(visitor.controllers[controller].displayName)
                ..type = MethodType.getter
                ..lambda = true
                ..body = Code('template.$controller');
            }),
          for (final String stream in visitor.streams.keys)
            Method((final MethodBuilder builder) {
              builder
                ..name = stream
                ..returns = Reference(visitor.streams[stream])
                ..type = MethodType.getter
                ..lambda = true
                ..body = Code('_$stream.stream');
            }),
          for (final String sink in visitor.sinks.keys)
            Method((final MethodBuilder builder) {
              builder
                ..name = sink
                ..returns = Reference(visitor.sinks[sink])
                ..type = MethodType.getter
                ..lambda = true
                ..body = Code('_$sink.sink');
            }),
          for (final String export in visitor.exports.keys) ...<Method>[
            Method((final MethodBuilder builder) {
              builder
                ..name = export
                ..returns = Reference(visitor.exports[export].displayName)
                ..type = MethodType.getter
                ..lambda = true
                ..body = Code('template.$export');
            }),
            Method((final MethodBuilder builder) {
              builder
                ..name = export
                ..requiredParameters
                    .add(Parameter((final ParameterBuilder builder) {
                  builder
                    ..name = export
                    ..type = Reference(visitor.exports[export].displayName);
                }))
                ..type = MethodType.setter
                ..lambda = true
                ..body = Code('template.$export = $export');
            }),
          ],
          for (final ServiceConnector service in visitor.services)
            Method((final MethodBuilder builder) {
              builder
                ..name = service.name
                ..returns = Reference(service.type.displayName)
                ..type = MethodType.getter
                ..lambda = true
                ..body = Code('template.${service.name}');
            }),
          for (final String controller in visitor.values.keys)
            for (final String name in visitor.values[controller].keys)
              Method((final MethodBuilder builder) {
                builder
                  ..name = name
                  ..returns =
                      Reference(visitor.values[controller][name].displayName)
                  ..type = MethodType.getter
                  ..lambda = true
                  ..body = Code('template.$name');
              }),
        ]);

      builder.constructors.add(Constructor((final ConstructorBuilder builder) {
        builder
          ..optionalParameters.addAll(<Parameter>[
            for (final String name in visitor.parameters.keys)
              Parameter((final ParameterBuilder builder) {
                builder
                  ..name = name
                  ..type = Reference(visitor.parameters[name].toString())
                  ..named = true;
              })
          ])
          ..initializers
              .add(Code('template = ${element.name}($initializerList)'))
          ..body = Code('''
            $mappers

            $values

            $serviceInitializers

            $valueInitializers
          ''');
      }));
    });

    return bloc.accept<StringSink>(DartEmitter()).toString();
  }
}
