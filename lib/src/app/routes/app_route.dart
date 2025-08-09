import 'package:atheer/src/app/constants/route_constants.dart';
import 'package:atheer/src/features/dashboard/presentation/screens/dashboard.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

final router = GoRouter(
  initialLocation: RouteConstants.login,
  routes: [
    GoRoute(
      path: RouteConstants.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteConstants.profile,
      builder: (context, state) => const SizedBox(),
    ),
  ],
  errorBuilder: (context, state) => const SizedBox(),
  redirect: (BuildContext context, GoRouterState state) {
    return null;
  },
);
