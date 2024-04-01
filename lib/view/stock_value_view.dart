import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_scan_parser_example/view/stock_detail_view.dart';

class StockValueView extends StatelessWidget {
  const StockValueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      List<dynamic> stockValues = ref.watch(stockValuesProvider.notifier).state;
      return Scaffold(
        appBar: AppBar(
          title: const Text(""),
        ),
        body: ListView.builder(
            itemCount: stockValues.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(stockValues[index].toString()),
              );
            }),
      );
    });
  }
}
