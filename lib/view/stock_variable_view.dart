import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_scan_parser_example/view/stock_detail_view.dart';

class StockVariableView extends StatelessWidget {
  const StockVariableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      Map<String, dynamic> stockVariable =
          ref.watch(stockVariableProvider.notifier).state;

      return Scaffold(
          appBar: AppBar(
            title: const Text(""),
          ),
          body: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // Border color
                width: 1.0, // Border width
              ),
            ),
            child: Column(
              children: [
                Text(stockVariable['study_type']),
                const SizedBox(
                  height: 20,
                ),
                const Text("Set Parameters"),
                const SizedBox(
                  height: 20,
                ),
                Text(stockVariable['parameter_name']),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      // Customize the border
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  controller: TextEditingController(
                      text: stockVariable['default_value'].toString()),
                ),
              ],
            ),
          ));
    });
  }
}
