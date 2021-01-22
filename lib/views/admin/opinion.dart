import 'package:flutter/material.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/forms/custom_opinion_form.dart';
import 'package:staff_portal/providers/opinion_provider.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/services/firebase_messaging_service.dart';

class Opinion extends StatelessWidget {
  static const id = 'opinion';
  final descriptionTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PreferenceProvider.of(context).activeSink(Opinion.id);
    final bloc = OpinionProvider.of(context);
    FirebaseMessagingService().configure(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 0.0),
        child: SingleChildScrollView(
          child: Container(
              height: height,
              decoration: BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage('assets/images/bg3.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  _buildIconWithTitle(context),
                  CustomOpinionForm(
                    bloc: bloc,
                    descriptionTextEditingController:
                        descriptionTextEditingController,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildIconWithTitle(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/ticket-logo-100.png',
          width: 100.0,
          height: 100.0,
        ),
        SizedBox(height: 5.0),
        Text(
          'Your Feedback',
          style: Theme.of(context).textTheme.headline6.copyWith(
                letterSpacing: 2.0,
                fontSize: 18.0,
                color: Colors.black87,
              ),
        ),
      ],
    );
  }
}
