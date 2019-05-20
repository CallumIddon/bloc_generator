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

import 'package:analyzer/dart/element/element.dart';

bool findMetadata(Element element, String metadataName) {
  bool foundMetadata = false;
  for (final ElementAnnotation metadata in element.metadata) {
    if (metadata.toSource().startsWith(metadataName)) {
      foundMetadata = true;
      break;
    }
  }
  return foundMetadata;
}

List<ElementAnnotation> getMetadata(Element element, String metadataName) {
  if (!findMetadata(element, metadataName)) {
    throw Exception('$element does not have a $metadataName');
  }
  final List<ElementAnnotation> foundMetadata = <ElementAnnotation>[];
  for (final ElementAnnotation metadata in element.metadata) {
    if (metadata.toSource().startsWith(metadataName)) {
      foundMetadata.add(metadata);
    }
  }
  return foundMetadata;
}

List<String> findInputs(ElementAnnotation metadata) => metadata
        .toSource()
        .split('(')[1]
        .split(')')[0]
        .split(', ')
        .map((String input) {
      String output = input;
      if (output.startsWith('\'') || output.startsWith('"')) {
        output = output.substring(1);
      }
      if (output.endsWith('\'') || output.endsWith('"')) {
        output = output.substring(0, output.length - 1);
      }
      return output;
    }).toList();

bool checkMethod(Element element) => element.toString().contains('(');

String findName(Element element) {
  final String name = element.toString();
  if (checkMethod(element)) {
    return name.substring(0, name.indexOf('('));
  }
  return name.split(' ').removeLast();
}

String findType(Element element) {
  if (checkMethod(element)) {
    final String type = element.toString().split('→').reversed.toList()[0];
    return type.substring(1);
  }
  final List<String> name = element.toString().split(' ').reversed.toList()
    ..removeAt(0);
  return name.join(' ');
}

String findTemplateType(Element element) {
  final List<String> typeList = findType(element).split('<')..removeAt(0);
  final String type = typeList.join('<');
  return type.substring(0, type.length - 1);
}
