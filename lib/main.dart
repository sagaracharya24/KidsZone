import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:kids_preschool/localization/locale_constant.dart';
import 'package:kids_preschool/localization/localizations_delegate.dart';
import 'package:kids_preschool/ui/category/category_screen.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/preference.dart';
import 'package:kids_preschool/utils/utils.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Preference().instance();
  await initPlugin();
  RequestConfiguration conf= RequestConfiguration(tagForChildDirectedTreatment: 1);
  MobileAds.instance.updateRequestConfiguration(conf);
  await MobileAds.instance.initialize();

  runApp( const MyApp());
}

Future<void> initPlugin() async {
  try {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      var _authStatus = await AppTrackingTransparency.requestTrackingAuthorization();
      Preference.shared.setString(Preference.trackStatus, _authStatus.toString());
    }
  } on PlatformException {
    Debug.printLog("Platform Exception");
  }

  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  Debug.printLog("UUID:" + uuid);
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();


  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  bool? isSound;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    precacheImage(const AssetImage("assets/background/bg_home.webp"), context);
    _getPreference();
    if (isSound!) {
      Utils.playAudio();
    }
    super.initState();
  }

  void _getPreference() {
    isSound = Preference.shared.getBool(Preference.isMusic) ?? true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getPreference();
      if (isSound!) {
        Utils.audioPlayer.resume();
      }
    } else {
      _getPreference();
      if (isSound!) {
        Utils.audioPlayer.pause();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeDependencies() async {
    _locale = getLocale();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      theme: ThemeData(
          splashColor: Colur.transparent,
          highlightColor: Colur.transparent,
          fontFamily: "Vanilla Extract"
      ),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
      ],
      localizationsDelegates:  const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colur.white,
            brightness: Brightness.dark
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colur.transparent,
        ),
      ),

      home: const AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colur.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: CategoryScreen(),
      ),
    );
  }
}



