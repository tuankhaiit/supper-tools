import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:super_tools/src/data/JsonParser.dart';
import 'package:super_tools/src/util/util.dart';

class JsonObject {
  final String name;
  HashMap<String, dynamic> children = HashMap();

  JsonObject({required this.name});

  void add(String key, dynamic value) {
    children.putIfAbsent(key, () => value);
  }

  @override
  int get hashCode => name.hashCode + _childrenHashCode();

  int _childrenHashCode() {
    int result = 0;
    children.forEach((key, value) {
      result += key.hashCode + Utils.dataTypeHashCode(value);
    });
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is JsonObject && children == other.children;
  }

  @override
  String toString() {
    return "$name: ${children.toString()}";
  }

  String toKotlinGsonDTO() {
    final StringBuffer buffer = StringBuffer("");
    buffer.writeln("data class ${name.toClassName()}(");
    children.forEach((key, value) {
      buffer.writeln("\t@Serialize(\"$key\")");
      buffer.writeln("\tval $key: ${Utils.kotlinPrimitiveDataType(value)}?,");
    });
    buffer.write(")");
    return buffer.toString();
  }

  List<JsonObject> findJsonObjects() {
    var objects = <JsonObject>[];
    children.forEach((key, value) {
      if (value is JsonObject) {
        Utils.addWithTheBestModel(objects, value);
        value.findJsonObjects().forEach((element) {
          Utils.addWithTheBestModel(objects, element);
        });
      } else if (value is JsonArray) {
        final item = value.items.first;
        if (item is JsonObject) {
          Utils.addWithTheBestModel(objects, item);
          item.findJsonObjects().forEach((element) {
            Utils.addWithTheBestModel(objects, element);
          });
        }
      }
    });
    return objects.toList();
  }

  void printResult() {
    final objects = findJsonObjects();
    debugPrint("${toKotlinGsonDTO()}\n");
    for (var element in objects) {
      debugPrint("${element.toKotlinGsonDTO()}\n");
    }
  }
}

class JsonArray {
  final String name;
  List<dynamic> items = [];

  JsonArray({required this.name});

  void add(dynamic item) {
    items.add(item);
  }

  @override
  String toString() {
    return "$name: ${items.toString()}";
  }
}
