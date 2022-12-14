import 'package:client_shared/config.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:ridy/chat/chat_view.dart';
import 'package:ridy/location_selection/location_selection_parent_view.dart';
import 'package:ridy/location_selection/welcome_card/location_history_item.dart';
import 'package:ridy/login/login_screen.dart';
import 'package:ridy/login/login_verification_screen.dart';
import 'package:ridy/login/privacy_policy_screen.dart';
import 'package:ridy/login/profile_update_screen.dart';
import 'package:ridy/main/bloc/jwt_cubit.dart';
import 'package:ridy/main/bloc/notification_evnt.dart';
import 'package:ridy/main/bloc/ride_history_event.dart';
import 'package:ridy/main/bloc/rider_profile_cubit.dart';
import 'package:ridy/main/logout_screen.dart';
import 'package:ridy/main/ride_history.dart';
import 'package:ridy/onboarding/pageview_cubit.dart';
import 'package:ridy/storage/sharedpreference.dart';
import 'address/address_list_view.dart';
import 'announcements/announcements_list_view.dart';
import 'history/trip_history_list_view.dart';
import 'main/favourite_location.dart';
import 'main/notification_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'login/profile_screen.dart';
import 'main/bloc/current_location_cubit.dart';
import 'main/bloc/main_bloc.dart';
import 'main/graphql_provider.dart';
import 'profile/profile_view.dart';
import 'reservations/reservation_list_view.dart';
import 'package:client_shared/theme/theme.dart';
import 'wallet/wallet_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Hive.registerAdapter(LocationHistoryItemAdapter());
  await Hive.openBox<List<LocationHistoryItem>>("history2");
  await Hive.openBox("user");
  if (!kIsWeb) {
    await CountryCodes.init();
    final locale = CountryCodes.detailsForLocale();
    if (locale.dialCode != null) {
      defaultCountryCode = locale.dialCode!;
    }
  }
  await Geolocator.requestPermission();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? verificationId;
  bool? onBoarding;

  Future getUser() async {
    verificationId = await SharedPrefManger.getVerificationId();
    onBoarding = await SharedPrefManger.getOnBoardingScreen();
  }

  @override
  void initState() {
    getUser();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainBloc()),
        BlocProvider(create: (context) => CurrentLocationCubit()),
        BlocProvider(create: (context) => RiderProfileCubit()),
        BlocProvider(create: (context) => JWTCubit()),
        BlocProvider(create: (context) => PageViewCubit()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => RideHistoryCubit()),
      ],
      child: MyGraphqlProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [defaultLifecycleObserver],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          routes: {
            'addresses': (context) => const AddressListView(),
            'locationSelectionParentView': (context) =>
                LocationSelectionParentView(),
            'privacyPolicy': (context) => const PrivacyPolicyScreen(),
            'loginVerificationCodeView': (context) => LogInVerificationScreen(),
            'loginScreen': (context) => LoginScreen(),
            'announcements': (context) => const AnnouncementsListView(),
            'history': (context) => const TripHistoryListView(),
            'favouriteLocation': (context) => const FavouriteLocation(),
            'wallet': (context) => const WalletView(),
            'rideHistory': (context) => RideHistory(),
            'logoutScreen': (context) => const LogoutScreen(),
            'notificationScreen': (context) => NotificationScreen(),
            'onBoardingScreen': (context) => OnBoardingScreen(),
            'chat': (context) => const ChatView(),
            'reserves': (context) => const ReservationListView(),
            'profileScreen': (context) => ProfileScreen(),
            'profileUpdateScreen': (context) => ProfileUpdateScreen(),
            'profile': (context) => BlocProvider.value(
                  value: context.read<RiderProfileCubit>(),
                  child: BlocProvider.value(
                    value: context.read<JWTCubit>(),
                    child: ProfileView(),
                  ),
                ),
          },
          theme: CustomTheme.theme1,
          home: verificationId == null
              ? PrivacyPolicyScreen()
              : onBoarding == null
                  ? ProfileScreen()
                  : LocationSelectionParentView(),
        ),
      ),
    );
  }
}
