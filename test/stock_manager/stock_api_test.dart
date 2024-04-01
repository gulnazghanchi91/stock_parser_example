import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:stock_scan_parser_example/model/stock_model.dart';
import 'package:stock_scan_parser_example/service/stock_service.dart';

// Create a mock HTTP client class using Mockito
class MockClient extends Mock implements http.Client {}

void main() {
  test('ApiService fetches data successfully', () async {
    // Create a mock HTTP client
    final mockClient = MockClient();

    // Create a mock JSON response
    final jsonResponse = '{"message": "Success"}';

    // Set up expectations for the mock client
    when(mockClient.get(Uri.parse('http://coding-assignment.bombayrunning.com/data.json')))
        .thenAnswer((_) async => http.Response(jsonResponse, 200));

    // Create a test environment with the mock client and the ApiService provider
    var httpProvider = Provider((ref) => http.Client());
    final container = ProviderContainer(overrides: [
      // Provide the mock client instead of the real http.Client
      httpProvider.overrideWithValue(mockClient),
    ]);

    // Get the ApiService from the test environment
    final apiService = container.read(stockServiceProvider);

    // Call the fetchData method on the ApiService
    final data = await apiService.getStock();

    // Parse the JSON response using the model class
    final parsedData = List<StockModel>.from(data.map((x) => StockModel.fromJson(x as Map<String, dynamic>)));

    // Verify that the fetchData method returns the expected data
    expect(data, parsedData);
  });
}