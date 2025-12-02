import 'package:frontend/features/analytics/screens/dashboard_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/notes/screens/notes_screen.dart';

class AppRouter {
  static final router = GoRouter(
    // initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: "/dashboard",
        builder: (context, state) => const DashboardScreen(),
      ),

      GoRoute(
        path: "/notes",
        builder: (context, state) => const NotesScreen(),
      ),
    ],
  );
}
