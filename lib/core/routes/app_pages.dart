import 'package:get/get.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/register_screen.dart';
import '../../presentation/screens/reset_password_screen.dart';
import '../../presentation/screens/dashboard_screen.dart';
import '../../presentation/screens/ticket_list_screen.dart';
import '../../presentation/screens/create_ticket_screen.dart';
import '../../presentation/screens/ticket_detail_screen.dart';
import '../../presentation/screens/profile_screen.dart';

class AppPages {
  static const INITIAL = '/splash';
  
  static final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: '/reset-password', page: () => ResetPasswordScreen()),
    GetPage(name: '/dashboard', page: () => DashboardScreen()),
    GetPage(name: '/tickets', page: () => TicketListScreen()),
    GetPage(name: '/create-ticket', page: () => CreateTicketScreen()),
    GetPage(name: '/ticket-detail/:id', page: () {
      final id = int.parse(Get.parameters['id']!);
      return TicketDetailScreen(ticketId: id);
    }),
    GetPage(name: '/profile', page: () => ProfileScreen()),
  ];
}