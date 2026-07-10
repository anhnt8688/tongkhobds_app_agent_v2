import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/controllers/auth_state.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/comparison/compare_screen.dart';
import '../../features/deposit/presentation/deposit_detail_screen.dart';
import '../../features/deposit/presentation/deposit_list_screen.dart';
import '../../features/legal_search/legal_search_screen.dart';
import '../../features/utilities/utilities_screen.dart';
import '../../features/webview/presentation/in_app_webview_screen.dart';
import '../storage/token_storage.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/appointments/data/appointments_api.dart';
import '../../features/appointments/presentation/appointment_detail_screen.dart';
import '../../features/appointments/presentation/appointments_screen.dart';
import '../../features/appointments/presentation/make_appointment_screen.dart';
import '../../features/realestate/data/models/property.dart';
import '../../features/realestate/data/models/property_detail.dart';
import '../../features/contracts/presentation/contract_join_preview_screen.dart';
import '../../features/contracts/presentation/contract_library_screen.dart';
import '../../features/contracts/presentation/contract_otp_screen.dart';
import '../../features/contracts/presentation/contract_preview_screen.dart';
import '../../features/contracts/presentation/contract_sign_success_screen.dart';
import '../../features/contracts/presentation/contract_sign_screen.dart';
import '../../features/contracts/presentation/contracts_screen.dart';
import '../../features/contracts/presentation/library_detail_screen.dart';
import '../../features/contracts/presentation/widgets/library_file_preview_screen.dart';
import '../../features/customers/data/models/customer.dart';
import '../../features/customers/presentation/customer_form_screen.dart';
import '../../features/customers/presentation/customers_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/demands/presentation/demand_create_screen.dart';
import '../../features/demands/presentation/demand_detail_screen.dart';
import '../../features/demands/presentation/demands_screen.dart';
import '../../features/consultation_sell/presentation/sell_lead_detail_screen.dart';
import '../../features/consultation_sell/presentation/sell_lead_form_screen.dart';
import '../../features/consultation_sell/presentation/sell_leads_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/loan/data/models/loan.dart';
import '../../features/loan/presentation/loan_calculator_screen.dart';
import '../../features/loan/presentation/loan_create_screen.dart';
import '../../features/loan/presentation/loan_detail_screen.dart';
import '../../features/loan/presentation/loan_hub_screen.dart';
import '../../features/loan/presentation/loan_packages_screen.dart';
import '../../features/loan/presentation/loan_profiles_screen.dart';
import '../../features/locations/locations_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/projects/presentation/apartment_status_screen.dart';
import '../../features/projects/presentation/project_detail_screen.dart';
import '../../features/projects/presentation/projects_screen.dart';
import '../../features/post/presentation/post_edit_screen.dart';
import '../../features/post/presentation/post_listing_screen.dart';
import '../../features/profile/presentation/account_info_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';
import '../../features/referral/presentation/referral_screen.dart';
import '../../features/profile/presentation/award_benefits_screen.dart';
import '../../features/profile/presentation/change_password_screen.dart';
import '../../features/kyc/presentation/kyc_pre_capture_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/rank/rank_screen.dart';
import '../../features/realestate/presentation/my_listings_screen.dart';
import '../../features/realestate/presentation/property_detail_screen.dart';
import '../../features/realestate/presentation/search_location_screen.dart';
import '../../features/realestate/presentation/search_screen.dart';
import '../../features/chat/presentation/chat_room_screen.dart';
import '../../features/chat/presentation/controllers/chat_room_controller.dart';
import '../../features/chat/presentation/inbox_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/team/data/team_api.dart';
import '../../features/team/presentation/team_activity_history_screen.dart';
import '../../features/team/presentation/team_member_detail_screen.dart';
import '../../features/team/presentation/team_tree_screen.dart';
import '../../features/transactions/presentation/transaction_detail_screen.dart';
import '../../features/transactions/presentation/transactions_screen.dart';
import '../../features/verification/data/models/verification_models.dart';
import '../../features/verification/presentation/verification_approve_success_screen.dart';
import '../../features/verification/presentation/verification_article_screen.dart';
import '../../features/verification/presentation/verification_form_screen.dart';
import '../../features/verification/presentation/verification_list_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

const _authRoutes = {'/login', '/otp', '/forgot', '/register', '/onboarding'};

final routerProvider = Provider<GoRouter>((ref) {
  // Rebuild routing decisions whenever auth state changes.
  final refresh = ValueNotifier(0);
  ref.listen(authControllerProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loc = state.matchedLocation;

      // Hold on splash until the session is resolved.
      if (auth.status == AuthStatus.unknown) {
        return loc == '/splash' ? null : '/splash';
      }

      final loggedIn = auth.status == AuthStatus.authenticated;
      final onAuth = _authRoutes.contains(loc) || loc == '/splash';

      if (!loggedIn) {
        // First launch → show onboarding intro before the login screen.
        final seen = ref.read(onboardingSeenProvider);
        if (seen == false && loc != '/onboarding') return '/onboarding';
        // Allow the area picker during registration (no auth required).
        if (loc == '/locations') return null;
        return onAuth && loc != '/splash' ? null : '/login';
      }
      if (loggedIn && onAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: '/otp',
        builder: (_, state) {
          // Optional handoff from registration: {phone, isSignup}.
          final extra = state.extra;
          final args = extra is Map ? extra : const {};
          return OtpScreen(
            phone: args['phone'] as String?,
            isSignup: args['isSignup'] == true,
          );
        },
      ),
      GoRoute(path: '/forgot', builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(
        path: '/property/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final owned = state.uri.queryParameters['owned'] == 'true';
          return PropertyDetailScreen(id: id, owned: owned);
        },
      ),
      GoRoute(
        path: '/post/edit',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            PostEditScreen(detail: state.extra as PropertyDetail),
      ),
      // Full-screen "Đăng tin" wizard pushed above the shell (keeps the back
      // stack) — used by flows like nhu-cầu-bán's "Tạo tin" task.
      GoRoute(
        path: '/post-create',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            PostListingScreen(sellLeadId: state.extra as int?),
      ),
      GoRoute(
        path: '/customers',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const CustomersScreen(),
      ),
      GoRoute(
        path: '/customers/add',
        parentNavigatorKey: _rootKey,
        builder: (_, __) =>
            const CustomerFormScreen(mode: CustomerFormMode.add),
      ),
      GoRoute(
        path: '/customers/edit',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => CustomerFormScreen(
          mode: CustomerFormMode.edit,
          customer: state.extra is Customer ? state.extra as Customer : null,
        ),
      ),
      GoRoute(
        path: '/customers/detail',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => CustomerFormScreen(
          mode: CustomerFormMode.detail,
          customer: state.extra is Customer ? state.extra as Customer : null,
        ),
      ),
      GoRoute(
        path: '/transactions',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const TransactionsScreen(),
      ),
      GoRoute(
        path: '/transaction/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TransactionDetailScreen(
            id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/demands',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const DemandsScreen(),
      ),
      GoRoute(
        path: '/nhu-cau-ban',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const SellLeadsScreen(),
      ),
      GoRoute(
        path: '/nhu-cau-ban/create',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const SellLeadFormScreen(),
      ),
      GoRoute(
        path: '/nhu-cau-ban/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => SellLeadDetailScreen(
            id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/demand/create',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const DemandCreateScreen(),
      ),
      GoRoute(
        path: '/demand/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => DemandDetailScreen(
            id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/contracts',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const ContractsScreen(),
      ),
      GoRoute(
        path: '/contract/join-preview',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const ContractJoinPreviewScreen(),
      ),
      GoRoute(
        path: '/contract/sign',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final extra = state.extra is Map ? state.extra as Map : const {};
          return ContractSignScreen(
            infoOffice: (extra['infoOffice'] as int?) ?? 1,
          );
        },
      ),
      GoRoute(
        path: '/contract/otp',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final extra = state.extra is Map ? state.extra as Map : const {};
          return ContractOtpScreen(
            phone: (extra['phone'] ?? '').toString(),
            signature: extra['signature'] as Uint8List?,
            infoOffice: (extra['infoOffice'] as int?) ?? 1,
          );
        },
      ),
      GoRoute(
        path: '/contract/sign-success',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final extra = state.extra is Map ? state.extra as Map : const {};
          return ContractSignSuccessScreen(
            pdfUrl: extra['pdfUrl']?.toString(),
            contractId: extra['contractId']?.toString(),
          );
        },
      ),
      GoRoute(
        path: '/contract/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final extra = state.extra is Map ? state.extra as Map : const {};
          return ContractPreviewScreen(
            id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
            viewOnly: extra['viewOnly'] == true,
            pdfUrl: extra['pdfUrl']?.toString(),
            title: extra['title']?.toString(),
            contractType: extra['contractType'],
            signingMethod: extra['signingMethod'],
          );
        },
      ),
      GoRoute(
        // Native PDF viewer for the signed CTV contract (v1 used SfPdfViewer,
        // not a webview — Android WebView can't render a PDF URL inline).
        path: '/contract-pdf',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final e = state.extra is Map ? state.extra as Map : const {};
          return LibraryFilePreviewScreen(
            url: (e['url'] ?? '').toString(),
            name: (e['title'] ?? 'Hợp đồng').toString(),
            forcePdf: true,
          );
        },
      ),
      GoRoute(
        path: '/contract-library',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const ContractLibraryScreen(),
      ),
      GoRoute(
        path: '/contract-library/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => LibraryDetailScreen(
            id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/projects',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const ProjectsScreen(),
      ),
      GoRoute(
        path: '/project/:code',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ApartmentStatusScreen(
          code: state.pathParameters['code'] ?? '',
          name: state.uri.queryParameters['name'],
        ),
      ),
      GoRoute(
        path: '/project-detail/:code',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            ProjectDetailScreen(code: state.pathParameters['code'] ?? ''),
      ),
      GoRoute(
        path: '/appointments',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: '/appointments/create',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final extra = state.extra;
          return MakeAppointmentScreen(
            property: extra is Property ? extra : null,
            editing: extra is Appointment ? extra : null,
          );
        },
      ),
      GoRoute(
        path: '/appointments/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => AppointmentDetailScreen(
            id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/my-listings',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const MyListingsScreen(),
      ),
      GoRoute(
        path: '/favorites',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/favorite-group/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => FavoriteItemsScreen(
          groupId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          name: state.uri.queryParameters['name'] ?? '',
        ),
      ),
      GoRoute(
        path: '/messages',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const InboxScreen(),
      ),
      GoRoute(
        path: '/chat',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ChatRoomScreen(
          args: state.extra is ChatRoomArgs
              ? state.extra as ChatRoomArgs
              : const ChatRoomArgs(),
        ),
      ),
      GoRoute(
        path: '/team/member/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TeamMemberDetailScreen(
            salesmanId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/team/tree/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TeamTreeScreen(
            salesmanId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/team/activity/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => TeamActivityHistoryScreen(
            salesmanId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/team',
        parentNavigatorKey: _rootKey,
        builder: (_, __) =>
            TeamMemberDetailScreen(salesmanId: ref.read(currentSalesmanIdProvider)),
      ),
      GoRoute(
        path: '/edit-profile',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AccountInfoScreen(),
      ),
      GoRoute(
        path: '/edit-profile/edit',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/kyc',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const KycPreCaptureScreen(),
      ),
      GoRoute(
        path: '/change-password',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/award-benefits',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const AwardBenefitsScreen(),
      ),
      GoRoute(
        path: '/referral',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const ReferralScreen(),
      ),
      GoRoute(
        path: '/real-estate-verification',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const VerificationListScreen(),
        routes: [
          GoRoute(
            path: 'article',
            parentNavigatorKey: _rootKey,
            builder: (_, state) =>
                VerificationArticleScreen(item: state.extra as VerificationItem),
          ),
          GoRoute(
            path: 'form',
            parentNavigatorKey: _rootKey,
            builder: (_, state) {
              final args = state.extra as Map<String, dynamic>;
              return VerificationFormScreen(
                item: args['item'] as VerificationItem,
                detail:
                    args['detail'] as VerificationSalesmanDetailResponse?,
              );
            },
          ),
          GoRoute(
            path: 'approve-success',
            parentNavigatorKey: _rootKey,
            builder: (_, state) => VerificationApproveSuccessScreen(
                realEstate: state.extra as VerificationRealEstateDetail),
          ),
        ],
      ),
      GoRoute(
        path: '/locations',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const LocationsScreen(),
      ),
      GoRoute(
        path: '/search-locations',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            SearchLocationScreen(args: state.extra as SearchLocationArgs?),
      ),
      GoRoute(
        path: '/compare',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const CompareScreen(),
      ),
      GoRoute(
        path: '/deposit',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const DepositListScreen(),
      ),
      GoRoute(
        path: '/deposit/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) =>
            DepositDetailScreen(id: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/utilities',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const UtilitiesScreen(),
      ),
      GoRoute(
        path: '/webview',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final args = state.extra is Map ? state.extra as Map : const {};
          return InAppWebViewScreen(
            url: (args['url'] ?? '').toString(),
            title: (args['title'] ?? 'Xem chi tiết').toString(),
          );
        },
      ),
      GoRoute(
        path: '/legal-search',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const LegalSearchScreen(),
      ),
      GoRoute(
        path: '/map',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final e = state.extra as ({double? lat, double? lng})?;
          return MapScreen(initialLat: e?.lat, initialLng: e?.lng);
        },
      ),
      GoRoute(
        path: '/rank',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const RankScreen(),
      ),
      GoRoute(
        path: '/loan',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const LoanHubScreen(),
      ),
      GoRoute(
        path: '/loan/calculator',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const LoanCalculatorScreen(),
      ),
      GoRoute(
        path: '/loan/create',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          // extra: {data: Loan} → edit; otherwise the calculator prefill map.
          final e = state.extra is Map ? state.extra as Map<String, dynamic> : null;
          return LoanCreateScreen(
            edit: e?['data'] is Loan ? e!['data'] as Loan : null,
            prefill: e?['data'] is Loan ? null : e,
          );
        },
      ),
      GoRoute(
        path: '/loan/profiles',
        parentNavigatorKey: _rootKey,
        builder: (_, __) => const LoanProfilesScreen(),
      ),
      GoRoute(
        path: '/loan/packages/:bankId',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => LoanPackagesScreen(
            bankId: int.tryParse(state.pathParameters['bankId'] ?? '') ?? 0),
      ),
      GoRoute(
        path: '/loan/profile/:id',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => LoanDetailScreen(
            id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/post', builder: (_, __) => const PostListingScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/notifications',
                builder: (_, __) => const NotificationsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/profile', builder: (_, __) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
  );
});
