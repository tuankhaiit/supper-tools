import 'package:super_tools/src/data/JsonParser.dart';
import 'package:super_tools/src/model/model.dart';
import 'package:super_tools/src/util/config.dart';

class Utils {
  static String kotlinPrimitiveDataType(dynamic value) {
    if (value is String) {
      return "String";
    } else if (value is double) {
      return "Double";
    } else if (value is int) {
      return "Long";
    } else if (value is JsonObject) {
      return "${Config.prefixClass}${value.name.capitalize()}${Config.suffixClass}";
    } else if (value is JsonArray) {
      return "List<${kotlinPrimitiveDataType(value.items.first)}>>";
    }
    return "Any";
  }

  static int dataTypeHashCode(dynamic value) {
    // Higher value, the high priority
    if (value is JsonObject) {
      return value.hashCode;
    } else if (value is JsonArray) {
      return value.hashCode;
    } else if (value is int) {
      return 3;
    } else if (value is double) {
      return 4;
    } else if (value is String) {
      return 5;
    }
    return 1;
  }

  static void addWithTheBestModel(List<JsonObject> objects, JsonObject object) {
    JsonObject? exist;
    for (var element in objects) {
      // Ensure 2 objects are the same name, key length and key name
      if (element.name == object.name &&
          element.children.length == object.children.length &&
          element.children.keys.join(",").hashCode ==
              object.children.keys.join(",").hashCode) {
        exist = element;
        break;
      }
    }
    if (exist != null) {
      // Higher hashcode, best model
      if (exist.hashCode < object.hashCode) {
        objects.remove(exist);
        objects.add(object);
      }
    } else {
      objects.add(object);
    }
  }
}
