import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/providers/incoming_ticket_provider.dart';
import 'package:staff_portal/providers/incoming_ticket_response_provider.dart';
import 'package:staff_portal/providers/login_provider.dart';
import 'package:staff_portal/providers/outgoing_ticket_create_provider.dart';
import 'package:staff_portal/providers/outgoing_ticket_provider.dart';
import 'package:staff_portal/providers/outgoing_ticket_response_provider.dart';
import 'package:staff_portal/providers/password_reset_provider.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/providers/profile_provider.dart';
import 'package:staff_portal/providers/register_provider.dart';
import 'package:staff_portal/providers/tickets_provider.dart';
import 'package:staff_portal/views/admin/dashboard.dart';
import 'package:staff_portal/views/admin/profile.dart';
import 'package:staff_portal/views/admin/tickets/incoming_ticket.dart';
import 'package:staff_portal/views/admin/tickets/incoming_ticket_response.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_create.dart';
import 'package:staff_portal/views/admin/tickets/outgoing_ticket_response.dart';
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
    return PreferenceProvider(
      child: TicketsProvider(
        child: OutgoingTicketResponseProvider(
          child: OutgoingTicketCreateProvider(
            child: OutgoingTicketProvider(
              child: IncomingTicketResponseProvider(
                child: IncomingTicketProvider(
                  child: ProfileProvider(
                    child: RegisterProvider(
                      child: PasswordResetProvider(
                        child: LoginProvider(
                          child: GetMaterialApp(
                            home: MaterialApp(
                              navigatorKey: navigatorKey,
                              title: kAppName,
                              theme: ThemeData(
                                  primarySwatch: kPrimaryColor,
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
                                Register.id: (BuildContext ctx) => Register(),
                                PasswordReset.id: (BuildContext ctx) =>
                                    PasswordReset(),
                                PageNotFound.id: (BuildContext ctx) =>
                                    PageNotFound(),
                                Dashboard.id: (BuildContext ctx) => Dashboard(),
                                Profile.id: (BuildContext ctx) => Profile(),
                                Opinion.id: (BuildContext ctx) => Opinion(),
                                IncomingTicket.id: (BuildContext ctx) =>
                                    IncomingTicket(),
                                OutgoingTicket.id: (BuildContext ctx) =>
                                    OutgoingTicket(),
                                IncomingTicketResponse.id: (BuildContext ctx) =>
                                    IncomingTicketResponse(),
                                OutgoingTicketResponse.id: (BuildContext ctx) =>
                                    OutgoingTicketResponse(),
                                OutgoingTicketCreate.id: (BuildContext ctx) =>
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
    );
  }
}

//TODO('Image Zoom')
//TODO('Work on the Incoming Ticket Response UI')
//TODO('Get auth_bg image from the femi/ezenma')
