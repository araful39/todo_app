import 'package:go_router/go_router.dart';
import 'package:todo_app/features/splash/screens/splash_screen.dart';
import 'package:todo_app/features/auth/screens/login_screen.dart';
import 'package:todo_app/features/auth/screens/register_screen.dart';
import 'package:todo_app/features/todo/presentation/screens/home_screen.dart';
import 'package:todo_app/features/profile/screens/profile_screen.dart';

class AppRouter {
  // Route names as constants for easy use
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
