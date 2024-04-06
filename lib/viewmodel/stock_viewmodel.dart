import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_scan_parser_example/model/stock_model.dart';
import 'package:stock_scan_parser_example/utils/strings.dart';

import '../service/stock_service.dart';

final stockViewModelProvider = Provider((ref) => StockViewModel());

class StockViewModel {
  Future<List<StockModel>> getStock(WidgetRef ref) async {
    try {
      return await ref.read(stockServiceProvider).getStock();
    } on SocketException catch (_) {
      print(noConnection);
      //showDialogFlash(context, noConnection);
      rethrow;
    } on TimeoutException catch (e) {
      print(timeout);
      //showDialogFlash(context, timeout);
      rethrow;
    } on Exception catch (e) {
      print(e.toString());
      //showDialogFlash(context, e.toString());
      rethrow;
    }
  }

  List<String> getDefaultValueToShow(Map<String, dynamic> value) {
    List<String> val = [];
    if (value['type'] == "value") {
      val.add(value['values']![0].toString());
    } else if (value['type'] == "indicator") {
      val.add(value["default_value"].toString());
    }
    return val;
  }

  Map<String, String> getDefaultValueType(value) {
    String defaultValue = "";
    Map<String, String> type = {};
    if (value['type'] == "value") {
      defaultValue = value['values']![0].toString();
      type[defaultValue] = value['type']!;
    } else if (value['type'] == "indicator") {
      defaultValue = value["default_value"].toString();
      type[defaultValue] = value['type']!;
    }
    return type;
  }

  List<dynamic> getMatchedTextForValue(value) {
    List<dynamic> matchedText = [];
    Map<String, dynamic> variableValue = value;
    if (variableValue['type'] == "value") {
      matchedText.addAll(variableValue['values']);
    }
    return matchedText;
  }

  findType(String part, Map<String, String> matchedTextsForType) {
    String clickedType = "";
    for (var key in matchedTextsForType.entries) {
      if (part.contains(key.key)) {
        clickedType = key.value;
      }
    }
    return clickedType;
  }

  Map<String, dynamic> findVariableValue(
      String part, Map<String, dynamic> matchedTextsForVariableValue) {
    Map<String, dynamic> clickedVariableValue = {};
    for (var key in matchedTextsForVariableValue.entries) {
      if (part.contains(key.key)) {
        clickedVariableValue = key.value;
      }
    }
    return clickedVariableValue;
  }

  List<dynamic> findValues(String part, List<dynamic> matchedTextsValue,
      Map<String, dynamic> matchedTextsForVariableValue) {
    List<dynamic> clickedVariableValue = [];
    for (var key in matchedTextsForVariableValue.entries) {
      if (part.contains(key.key.toString())) {
        clickedVariableValue.addAll(key.value['values']);
      }
    }
    return clickedVariableValue;
  }
}
