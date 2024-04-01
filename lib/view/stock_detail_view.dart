import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_scan_parser_example/view/stock_list_view.dart';

import '../model/stock_model.dart';
import '../utils/strings.dart';
import '../utils/util_functions.dart';

final stockVariableProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final stockValuesProvider = StateProvider<List<dynamic>>((ref) => []);

class StockDetailView extends StatelessWidget {
  StockDetailView({super.key});

  Map<String, String> defValueListForType = {};

  Map<String, dynamic> variableValueTemp = {};

  List<dynamic> matchedTextsForValue = [];

  List<String> defValueList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      StockModel stockDetail = ref.watch(stockDetailProvider.notifier).state;

      return Scaffold(
        appBar: AppBar(
          title: Text(stockDetail.name),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 1.0, // Border width
                ),
              ),
              child: Column(
                children: [
                  Text(
                    stockDetail.name,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(stockDetail.tag,
                      style: TextStyle(
                          color: getStockTagColor(stockDetail.color))),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: drawCriteriaList(stockDetail.criteria, context, ref),
            )
          ],
        ),
      );
    });
  }

  drawCriteriaList(
    List<Criterion> criteria,
    context,
    ref,
  ) {
    List<Widget> criteriaList = [];
    String orgText = "";
    defValueList = [];
    defValueListForType = {};
    variableValueTemp = {};
    matchedTextsForValue = [];
    for (int i = 0; i < criteria.length; i++) {
      orgText = criteria[i].text;
      if (criteria[i].type == "variable") {
        Map<String, dynamic> variableData = criteria[i].variable!;

        variableData.forEach((variableKey /* $1 */,
            variableValue /*  {type: '', values: '', study_type: '', etc} */) {
          print('Key: $variableKey, Value: $variableValue');
          if (criteria[i].text.contains(variableKey)) {
            var defValue = decideDefaultValueForKey(variableValue);
            orgText = orgText.replaceAll(variableKey, defValue);
          }
        });
      }
      print("orgText: $orgText defValue: $defValueList");
      criteriaList.add(drawRichText(orgText, defValueList, defValueListForType,
          ref, variableValueTemp, context, matchedTextsForValue));
      criteriaList.add(
        i != criteria.length - 1 ? const Text("and") : Container(),
      );
      criteriaList.add(
        const SizedBox(
          height: 20,
        ),
      );
    }
    return criteriaList;
  }

  // value = {type: '', values: '', study_type: '', etc}
  decideDefaultValueForKey(value) {
    String defaultValue = "";
    Map<String, dynamic> variableValue = value;
    if (variableValue['type'] == "value") {
      defaultValue = variableValue['values']![0].toString();
      defValueList.add(defaultValue);
      defValueListForType[defaultValue] = variableValue['type']!;
      variableValueTemp[defaultValue] = variableValue;
      matchedTextsForValue.addAll(variableValue['values']);
    } else if (variableValue['type'] == "indicator") {
      defaultValue = variableValue["default_value"].toString();
      defValueList.add(defaultValue);
      defValueListForType[defaultValue] = variableValue['type']!;
      variableValueTemp[defaultValue] = variableValue;
      matchedTextsForValue = [];
    }
    return defaultValue;
  }

  drawRichText(
      orgText,
      List<String> defValueList,
      Map<String, String> defValueListForType,
      ref,
      Map<String, dynamic> variableValue,
      context,
      List<dynamic> matchedTextsForValue) {
    return RichText(
      text: TextSpan(
        children: _buildTextSpans(orgText, defValueList, defValueListForType,
            ref, variableValue, context, matchedTextsForValue),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(
      String orgText,
      List<String> matchedText,
      Map<String, String> matchedTextForType,
      ref,
      Map<String, dynamic> variableValue,
      context,
      List<dynamic> matchedTextsForValue) {
    List<TextSpan> textSpans = [];

    // Split original text into parts based on matched words
    List<String> parts = orgText.split(RegExp(r'(\b|[^\w-])'));

    // Loop through the parts and add TextSpan widgets
    for (int i = 0; i < parts.length; i++) {
      //print('Key: ${mapEntry},');
      String part = parts[i];
      bool isMatched = matchedText.contains(part);
      if (isMatched) {
        // Add underlined text
        textSpans.add(
          TextSpan(
            text: part,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                String clickedType = findType(part, matchedTextForType);
                print('Link tapped $clickedType');

                if (clickedType.contains("indicator")) {
                  ref.watch(stockVariableProvider.notifier).state =
                      findVariableValue(part, variableValue);
                  GoRouter.of(context).go(variableRouterPath);
                } else {
                  print("My V Type $variableValue");
                  print("My Values $matchedTextsForValue");
                  ref.watch(stockValuesProvider.notifier).state =
                      findValues(part, matchedTextsForValue, variableValue);
                  GoRouter.of(context).go(valueRouterPath);
                }
              },
          ),
        );
      } else {
        // Add normal text
        textSpans.add(TextSpan(
          text: part,
          style: const TextStyle(
            color: Colors.black,
          ),
        ));
      }
    }

    return textSpans;
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
