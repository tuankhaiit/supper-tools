import 'dart:convert';

import 'package:super_tools/src/model/model.dart';
import 'package:super_tools/src/util/config.dart';

const String source =
    "{\"error\":null,\"message\":null,\"data\":{\"product\":{\"code\":\"pa_hcvn_01\",\"period\":\"1Y\",\"insurancePackage\":\"pa_hcvn_01_g1\"},\"policyHolder\":{\"name\":\"Jenny Stonehouse\",\"dob\":\"03/07/1984\",\"address\":{\"address\":\"16 Phan Chu Trinh, Ha Noi\",\"districtId\":null,\"districtName\":null,\"provinceId\":1,\"provinceName\":\"Thành phố Hà Nội\"},\"email\":\"hoan_vukhac@vn.msig-asia.com\",\"phoneNumber\":\"0906120581\",\"idNumber\":\"052064000034\",\"idType\":\"identity_number\",\"nationality\":\"chn\",\"nationalityName\":\"Trung Quốc\",\"cif\":10000000,\"gender\":\"m\",\"genderTitle\":\"Nam\",\"relationship\":null,\"relationshipTitle\":null},\"insuredPersons\":[{\"name\":\"Adam Huson\",\"dob\":\"03/07/1984\",\"address\":{\"address\":null,\"districtId\":null,\"districtName\":null,\"provinceId\":null,\"provinceName\":null},\"email\":null,\"phoneNumber\":null,\"idNumber\":\"052064000035\",\"idType\":\"identity_number\",\"nationality\":\"chn\",\"nationalityName\":\"Trung Quốc\",\"cif\":null,\"gender\":\"m\",\"genderTitle\":\"Nam\",\"relationship\":\"child\",\"relationshipTitle\":\"Con ruột\"}],\"saleStaff\":{\"contractId\":1063039,\"staffCode\":\"123456\"}}}";

class JsonParser {
  static dynamic parseFrom(dynamic source, String name) {
    if (source is String) {
      if (source.isJsonObjectFormat()) {
        return parseObject(source, name);
      } else if (source.isJsonArrayFormat()) {
        return parseArrayObject(source, name);
      }
    } else if (source is Map) {
      return parseObjectFromMap(source, name);
    } else if (source is List) {
      return parseArrayObjectFromList(source, name);
    }
    return source;
  }

  static JsonObject parseObject(String source, String name) {
    final JsonObject jsonObject = JsonObject(name: name);
    final Map<String, dynamic> parsed = jsonDecode(source);
    parsed.forEach((key, value) {
      jsonObject.add(key, parseFrom(value, key));
    });
    return jsonObject;
  }

  static JsonObject parseObjectFromMap(Map parsed, String name) {
    final JsonObject jsonObject = JsonObject(name: name);
    parsed.forEach((key, value) {
      jsonObject.add(key.toString(), parseFrom(value, key));
    });
    return jsonObject;
  }

  static JsonArray parseArrayObject(String source, String name) {
    final JsonArray jsonArray = JsonArray(name: name);
    final List<dynamic> parsed = jsonDecode(source);
    for (var item in parsed) {
      jsonArray.add(parseFrom(item, name));
    }
    return jsonArray;
  }

  static JsonArray parseArrayObjectFromList(List<dynamic> source, String name) {
    final JsonArray jsonArray = JsonArray(name: name.removePlural());
    for (var item in source) {
      jsonArray.add(parseFrom(item, name.removePlural()));
    }
    return jsonArray;
  }
}

extension JsonStringExtensions on String {
  bool isJsonObjectFormat() {
    return startsWith("{") && endsWith("}");
  }

  bool isJsonArrayFormat() {
    return startsWith("[") && endsWith("]");
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String removePlural() {
    if (endsWith("s")) {
      return substring(0, length - 1);
    } else {
      return this;
    }
  }

  String toClassName() {
    return "${Config.prefixClass}${capitalize()}${Config.suffixClass}";
  }
}
