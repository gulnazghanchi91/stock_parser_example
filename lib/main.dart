import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stock_scan_parser_example/utils/strings.dart';
import 'package:stock_scan_parser_example/view/stock_detail_view.dart';
import 'package:stock_scan_parser_example/view/stock_list_view.dart';
import 'package:stock_scan_parser_example/view/stock_value_view.dart';
import 'package:stock_scan_parser_example/view/stock_variable_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: mainRouter,
      builder: (BuildContext context, GoRouterState state) {
        return const StockListView();
      },
      routes: <RouteBase>[
        GoRoute(
          path: detailRouter,
          builder: (BuildContext context, GoRouterState state) {
            return StockDetailView();
          },
          routes: <RouteBase>[
            GoRoute(
              path: variableRouter,
              builder: (BuildContext context, GoRouterState state) {
                return const StockVariableView();
              },
            ),
            GoRoute(
              path: valueRouter,
              builder: (BuildContext context, GoRouterState state) {
                return const StockValueView();
              },
            )
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
