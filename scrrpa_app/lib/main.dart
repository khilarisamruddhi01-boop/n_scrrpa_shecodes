import 'package:flutter/material.dart';
import 'design_system.dart';
import 'screens/admin_dashboard_s36.dart';
import 'screens/alert_center_s33.dart';
import 'screens/audit_logs_s42.dart';
import 'screens/cascade_simulation_s29.dart';
import 'screens/customer_dashboard_s17.dart';
import 'screens/customer_detail_s14.dart';
import 'screens/customer_network_s13.dart';
import 'screens/customer_orders_s21.dart';
import 'screens/customer_shipment_tracking_s22.dart';
import 'screens/data_sources_s39.dart';
import 'screens/disruption_prediction_s28.dart';
import 'screens/email_verification_s05.dart';
import 'screens/forgot_password_screen_s06.dart';
import 'screens/help_center_s45.dart';
import 'screens/main_dashboard_s25.dart';
import 'screens/network_map_s26.dart';
import 'screens/onboarding_carousel_s02.dart';
import 'screens/order_detail_s10.dart';
import 'screens/password_reset_s07.dart';
import 'screens/place_order_s20.dart';
import 'screens/profile_s43.dart';
import 'screens/recommendation_engine_s30.dart';
import 'screens/register_screen_s04.dart';
import 'screens/report_generator_s34.dart';
import 'screens/report_viewer_s35.dart';
import 'screens/risk_intelligence_s27.dart';
import 'screens/risk_model_settings_s40.dart';
import 'screens/risk_model_tuning_s40.dart';
import 'screens/role_selection.dart';
import 'screens/route_optimization_s31.dart';
import 'screens/s01_splash_screen.dart';
import 'screens/s03_login_screen.dart';
import 'screens/settings_s44.dart';
import 'screens/shipment_preparation_s11.dart';
import 'screens/shipment_tracking_s12.dart';
import 'screens/supplier_analytics_s15.dart';
import 'screens/supplier_analytics_s23.dart';
import 'screens/supplier_approvals_s38.dart';
import 'screens/supplier_dashboard_s08.dart';
import 'screens/supplier_feedback_s24.dart';
import 'screens/supplier_orders_s09.dart';
import 'screens/supplier_profile_s19.dart';
import 'screens/supplier_reports_s16.dart';
import 'screens/supplier_search_s18.dart';
import 'screens/system_health_s41.dart';
import 'screens/user_management_s37.dart';
import 'package:scrrpa_app/screens/admin_login_s03.dart';
import 'package:scrrpa_app/screens/customer_login_s03.dart';
import 'package:scrrpa_app/screens/supplier_login_s03.dart';
import 'screens/vulnerability_scanner_s32.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Requires google-services.json / GoogleService-Info.plist)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize Remote Config
    final rcService = RemoteConfigService();
    await rcService.initialize();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(
    const ProviderScope(
      child: ScrrpaApp(),
    ),
  );
}

class ScrrpaApp extends ConsumerWidget {
  const ScrrpaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'SCRPPA Flow',
      theme: SCRRATheme.light,
      initialRoute: '/s01_splash_screen',
      routes: {
        '/admin_dashboard_s36': (context) => const AdminDashboardS36Screen(),
        '/alert_center_s33': (context) => const AlertCenterS33Screen(),
        '/audit_logs_s42': (context) => const AuditLogsS42Screen(),
        '/cascade_simulation_s29': (context) => const CascadeSimulationS29Screen(),
        '/customer_dashboard_s17': (context) => const CustomerDashboardS17Screen(),
        '/customer_detail_s14': (context) => const CustomerDetailS14Screen(),
        '/customer_network_s13': (context) => const CustomerNetworkS13Screen(),
        '/customer_orders_s21': (context) => const CustomerOrdersS21Screen(),
        '/customer_shipment_tracking_s22': (context) => const CustomerShipmentTrackingS22Screen(),
        '/data_sources_s39': (context) => const DataSourcesS39Screen(),
        '/disruption_prediction_s28': (context) => const DisruptionPredictionS28Screen(),
        '/email_verification_s05': (context) => const EmailVerificationScreen(),
        '/forgot_password_screen_s06': (context) => const ForgotPasswordScreenS06Screen(),
        '/help_center_s45': (context) => const HelpCenterS45Screen(),
        '/main_dashboard_s25': (context) => const MainDashboardS25Screen(),
        '/network_map_s26': (context) => const NetworkMapS26Screen(),
        '/onboarding_carousel_s02': (context) => const OnboardingCarouselScreen(),
        '/order_detail_s10': (context) => const OrderDetailS10Screen(),
        '/password_reset_s07': (context) => const PasswordResetS07Screen(),
        '/place_order_s20': (context) => const PlaceOrderS20Screen(),
        '/profile_s43': (context) => const ProfileS43Screen(),
        '/recommendation_engine_s30': (context) => const RecommendationEngineS30Screen(),
        '/register_screen_s04': (context) => const RegisterScreen(),
        '/report_generator_s34': (context) => const ReportGeneratorS34Screen(),
        '/report_viewer_s35': (context) => const ReportViewerS35Screen(),
        '/risk_intelligence_s27': (context) => const RiskIntelligenceS27Screen(),
        '/risk_model_settings_s40': (context) => const RiskModelSettingsS40Screen(),
        '/risk_model_tuning_s40': (context) => const RiskModelTuningS40Screen(),
        '/role_selection': (context) => const RoleSelectionScreen(),
        '/route_optimization_s31': (context) => const RouteOptimizationS31Screen(),
        '/s01_splash_screen': (context) => const S01SplashScreen(),
        '/s03_login_screen': (context) => const S03LoginScreen(),
        '/settings_s44': (context) => const SettingsS44Screen(),
        '/shipment_preparation_s11': (context) => const ShipmentPreparationS11Screen(),
        '/shipment_tracking_s12': (context) => const ShipmentTrackingS12Screen(),
        '/supplier_analytics_s15': (context) => const SupplierAnalyticsS15Screen(),
        '/supplier_analytics_s23': (context) => const SupplierAnalyticsS23Screen(),
        '/supplier_approvals_s38': (context) => const SupplierApprovalsS38Screen(),
        '/supplier_dashboard_s08': (context) => const SupplierDashboardS08Screen(),
        '/supplier_feedback_s24': (context) => const SupplierFeedbackS24Screen(),
        '/supplier_orders_s09': (context) => const SupplierOrdersS09Screen(),
        '/supplier_profile_s19': (context) => const SupplierProfileS19Screen(),
        '/supplier_reports_s16': (context) => const SupplierReportsS16Screen(),
        '/supplier_search_s18': (context) => const SupplierSearchS18Screen(),
        '/system_health_s41': (context) => const SystemHealthS41Screen(),
        '/user_management_s37': (context) => const UserManagementS37Screen(),
        '/vulnerability_scanner_s32': (context) => const VulnerabilityScannerS32Screen(),
        '/supplier_login_s03': (context) => const SupplierLoginS03Screen(),
        '/customer_login_s03': (context) => const CustomerLoginS03Screen(),
        '/admin_login_s03': (context) => const AdminLoginS03Screen(),
      },
    );
  }
}
