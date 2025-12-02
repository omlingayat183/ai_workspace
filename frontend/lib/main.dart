import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.init();

  runApp(const ProviderScope(child: AiWorkspaceApp()));
}

class AiWorkspaceApp extends StatelessWidget {
  const AiWorkspaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Workspace',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
