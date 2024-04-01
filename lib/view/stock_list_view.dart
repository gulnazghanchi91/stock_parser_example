import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_scan_parser_example/model/stock_model.dart';
import 'package:stock_scan_parser_example/viewmodel/stock_viewmodel.dart';

import '../utils/strings.dart';
import '../utils/util_functions.dart';

final stockListViewFutureProvider = FutureProvider.family((
  ref,
  WidgetRef _ref,
) async =>
    ref.watch(stockViewModelProvider).getStock(_ref));

final stockDetailProvider = StateProvider<StockModel>(
    (ref) => StockModel(id: 0, name: '', tag: '', color: '', criteria: []));

class StockListView extends StatelessWidget {
  const StockListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final n = ref.watch(stockViewModelProvider);
      final stockList = ref.watch(stockListViewFutureProvider(ref));
      return Scaffold(
        body: stockList.when(
            data: (data) => SafeArea(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return viewListItem(data[index].name, data[index].tag,
                          data[index].color, context, ref, data[index]);
                    })),
            error: (error, trace) => const Center(
                  child: Text(apiFailed),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )),
      );
    });
  }

  viewListItem(name, tag, color, context, ref, dataIndex) {
    return InkWell(
      onTap: () {
        ref.watch(stockDetailProvider.notifier).state = dataIndex;
        GoRouter.of(context).go(detailRouterPath);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(tag,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: getStockTagColor(color))),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
