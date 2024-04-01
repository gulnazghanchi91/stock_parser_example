import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:stock_scan_parser_example/model/stock_model.dart';

final stockServiceProvider = Provider((ref) => StockServiceImpl());

abstract class StockService {
  Future getStock();
}

class StockServiceImpl extends StockService {
  final _client = Client();
  final baseUrl = "http://coding-assignment.bombayrunning.com/data.json";

  @override
  Future<List<StockModel>> getStock() async {
    final response = await _client.get(Uri.parse(baseUrl));
    final data = json.decode(response.body);
    print(data);
    return List<StockModel>.from(data.map((x) => StockModel.fromJson(x)));
  }
}
