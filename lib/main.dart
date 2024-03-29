import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/providers/dashboard_provider.dart';
import 'package:staff_portal/providers/download_service_provider.dart';
import 'package:staff_portal/providers/incoming_ticket_provider.dart';
import 'package:staff_portal/providers/login_provider.dart';
import 'package:staff_portal/providers/opinion_provider.dart';
import 'package:staff_portal/providers/outgoing_ticket_create_provider.dart';
import 'package:staff_portal/providers/outgoing_ticket_provider.dart';
import 'package:staff_portal/providers/password_reset_provider.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/providers/profile_provider.dart';
import 'package:staff_portal/providers/register_provider.dart';
import 'package:staff_portal/providers/ticket_response_provider.dart';
import 'package:staff_portal/providers/tickets_provider.dart';
import 'package:staff_portal/views/admin/dashboard.dart';
import 'package:staff_portal/views/admin/profile.dart';
import 'package:staff_portal/views/admin/tickets/incoming_ticket.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_create.dart';
import 'package:staff_portal/views/admin/tickets/ticket_response.dart';
import 'package:staff_portal/views/login.dart';
import 'package:staff_portal/views/page_not_found.dart';
import 'package:staff_portal/views/password_reset.dart';
import 'package:staff_portal/views/register.dart';
import 'package:staff_portal/views/splash.dart';
import 'package:staff_portal/views/welcome.dart';
import './views/admin/opinion.dart';
import 'package:get/get.dart';
import './views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return DownloadServiceProvider(
      child: PreferenceProvider(
        child: TicketsProvider(
          child: OutgoingTicketCreateProvider(
            child: OutgoingTicketProvider(
              child: IncomingTicketProvider(
                child: TicketResponseProvider(
                  child: OpinionProvider(
                    child: DashboardProvider(
                      child: ProfileProvider(
                        child: RegisterProvider(
                          child: PasswordResetProvider(
                            child: LoginProvider(
                              child: GetMaterialApp(
                                home: MaterialApp(
                                  // locale: DevicePreview.locale(
                                  //     context), // Add the locale here
                                  // builder: DevicePreview
                                  //     .appBuilder, // Add the builde
                                  navigatorKey: navigatorKey,
                                  title: kAppName,
                                  theme: ThemeData(
                                      primarySwatch: kPrimaryColor,
                                      visualDensity:
                                          VisualDensity.adaptivePlatformDensity,
                                      textTheme: TextTheme(
                                        headline6: TextStyle(
                                          color: kTertiaryColor,
                                          fontSize: 18.0,
                                        ),
                                      )),
                                  initialRoute: Splash.id,
                                  routes: {
                                    Home.id: (BuildContext ctx) => Home(),
                                    Splash.id: (BuildContext ctx) => Splash(),
                                    Welcome.id: (BuildContext ctx) => Welcome(),
                                    Login.id: (BuildContext ctx) => Login(),
                                    Register.id: (BuildContext ctx) =>
                                        Register(),
                                    PasswordReset.id: (BuildContext ctx) =>
                                        PasswordReset(),
                                    PageNotFound.id: (BuildContext ctx) =>
                                        PageNotFound(),
                                    Dashboard.id: (BuildContext ctx) =>
                                        Dashboard(),
                                    Profile.id: (BuildContext ctx) => Profile(),
                                    Opinion.id: (BuildContext ctx) => Opinion(),
                                    IncomingTicket.id: (BuildContext ctx) =>
                                        IncomingTicket(),
                                    OutgoingTicket.id: (BuildContext ctx) =>
                                        OutgoingTicket(),
                                    TicketResponse.id: (BuildContext ctx) =>
                                        TicketResponse(),
                                    OutgoingTicketCreate.id:
                                        (BuildContext ctx) =>
                                            OutgoingTicketCreate(),
                                  },
                                  onUnknownRoute: (settings) {
                                    return MaterialPageRoute(
                                        builder: (_) => PageNotFound());
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//TODO('Push Notification Sound')
