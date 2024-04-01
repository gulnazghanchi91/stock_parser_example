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
}
