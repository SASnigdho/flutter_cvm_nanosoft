import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({super.key, this.error});

  final GoException? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('${error?.message}')),
    );
  }
}
