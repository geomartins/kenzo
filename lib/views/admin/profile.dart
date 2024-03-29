import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:staff_portal/blocs/profile_bloc.dart';
import 'package:staff_portal/components/custom_bottom_navigation_bar.dart';
import 'package:staff_portal/components/custom_flat_button.dart';
import 'package:staff_portal/components/custom_offstage_progress_indicator.dart';
import 'package:staff_portal/components/custom_outline_button.dart';
import 'package:staff_portal/config/constants.dart';
import 'package:staff_portal/mixins/get_snackbar.dart';
import 'package:staff_portal/models/profile_model.dart';
import 'package:staff_portal/providers/preference_provider.dart';
import 'package:staff_portal/providers/profile_provider.dart';
import 'package:staff_portal/services/auth_service.dart';
import 'package:staff_portal/components/builders/custom_auth_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staff_portal/services/firebase_messaging_service.dart';

class Profile extends StatelessWidget with GetSnackbar {
  static const id = 'profile';
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    FirebaseMessagingService().configure(context);
    PreferenceProvider.of(context).activeSink(id);
    final bloc = ProfileProvider.of(context);
    bloc.fetchProfile();

    return CustomAuthBuilder(
      child: Scaffold(
        key: _drawerKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: AuthService().getDisplayName(type: 'ucwords') != null
              ? Text(
                  AuthService().getDisplayName(type: 'ucwords'),
                  style: TextStyle(color: Colors.black),
                )
              : Container(),
          leading: StreamBuilder<bool>(
              stream: bloc.isLoading,
              initialData: false,
              builder: (context, snapshot) {
                return CustomOffstageProgressIndicator(status: !snapshot.data);
              }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () => _editProfileModalBottomSheet(context, bloc),
                child: Icon(
                  Icons.person_pin,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
            ),
          ],
          elevation: 0.0,
          centerTitle: true,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        body: SafeArea(
          minimum: EdgeInsets.all(10.0),
          left: true,
          right: true,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  //SizedBox(height: 30.0),
                  _buildCover(context, bloc),
                  Positioned(
                    child: _buildProfileAvatar(),
                    bottom: -30.0,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              _buildListTile(context, bloc),
              _buildButtons(context, bloc),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildCover(BuildContext context, ProfileBloc bloc) {
    return Stack(
      children: [
        StreamBuilder<ProfileModel>(
            stream: bloc.profile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      scale: 50.0,
                      alignment: Alignment.topCenter,
                      image: snapshot.hasData && snapshot.data != null
                          ? NetworkImage(snapshot.data.coverUrl)
                          : AssetImage(kDefaultCoverUrl),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 3,
                );
              } else {
                return CustomOffstageProgressIndicator(status: false);
              }
            }),
        Positioned(
          child: GestureDetector(
            onTap: () => _editProfileModalBottomSheet(context, bloc),
            child: Container(
              child: Icon(Icons.camera),
              color: Colors.white,
              padding: EdgeInsets.all(5.0),
            ),
          ),
          bottom: 20.0,
          right: 20.0,
        ),
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        new Container(
          width: 100.0,
          height: 100.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: AuthService().getPhotoUrl() != null
                  ? NetworkImage(AuthService().getPhotoUrl())
                  : AssetImage(kDefaultProfileUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
            border: new Border.all(
              color: Colors.white,
              width: 4.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context, bloc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CustomOutlineButton(
            color: Colors.white,
            title: 'Edit Profile',
            onPressed: () => _editProfileModalBottomSheet(context, bloc),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: CustomFlatButton(
            color: kPrimaryColor,
            title: 'Logout',
            onPressed: () async {
              try {
                await AuthService().logout();
              } on PlatformException catch (e) {
                buildCustomSnackbar(
                    messageText: e.message,
                    titleText: "Oops",
                    iconColor: Colors.red,
                    icon: Icons.error);
              }
            },
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, ProfileBloc bloc) {
    return StreamBuilder<ProfileModel>(
        stream: bloc.profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            String email = snapshot.hasData && snapshot.data != null
                ? snapshot.data.email
                : 'unknown';
            String department = snapshot.hasData && snapshot.data != null
                ? snapshot.data.department
                : 'unknown';
            String role = snapshot.hasData && snapshot.data != null
                ? snapshot.data.role
                : 'unknown';

            return Column(
              children: [
                ListTile(
                  subtitle: Text(
                    'Email Address',
                    style: TextStyle(letterSpacing: 1.0),
                  ),
                  title: Text(email),
                  leading: Icon(
                    Icons.email_outlined,
                    color: kPrimaryColor,
                  ),
                  trailing: Icon(Icons.accessibility_new),
                ),
                ListTile(
                  subtitle: Text(
                    'Department',
                    style: TextStyle(letterSpacing: 1.0),
                  ),
                  title: Text(department),
                  leading: Icon(
                    Icons.account_balance,
                    color: kPrimaryColor,
                  ),
                  trailing: Icon(Icons.accessibility_new),
                ),
                ListTile(
                  subtitle: Text(
                    'Job Role',
                    style: TextStyle(letterSpacing: 1.0),
                  ),
                  title: Text(role),
                  leading: Icon(
                    Icons.pages,
                    color: kPrimaryColor,
                  ),
                  trailing: Icon(Icons.accessibility_new),
                ),
              ],
            );
          } else {
            return CustomOffstageProgressIndicator(status: false);
          }
        });
  }

  void _editProfileModalBottomSheet(BuildContext context, ProfileBloc bloc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                  leading: new Icon(
                    Icons.camera_enhance,
                    color: kPrimaryColor,
                  ),
                  title: new Text('Change Profile Cover'),
                  onTap: () async {
                    bloc.loadingSink(true);
                    try {
                      await getImage(false, bloc, context);
                      await bloc.uploadCover();

                      buildCustomSnackbar(
                          messageText: 'Image Upload Successful',
                          titleText: "Success",
                          iconColor: kPrimaryColor,
                          icon: Icons.info);
                      Navigator.pushNamed(context, Profile.id);
                    } on PlatformException catch (e) {
                      buildCustomSnackbar(
                          messageText: e.message,
                          titleText: "Oops",
                          iconColor: Colors.red,
                          icon: Icons.error);
                    } finally {
                      bloc.loadingSink(false);
                    }
                  }),
              new ListTile(
                leading: new Icon(
                  Icons.camera_enhance,
                  color: kPrimaryColor,
                ),
                title: new Text('Change Profile Pix'),
                onTap: () async {
                  bloc.loadingSink(true);
                  try {
                    await getImage(false, bloc, context);
                    await bloc.uploadProfile();

                    buildCustomSnackbar(
                        messageText: 'Image Upload Successful',
                        titleText: "Success",
                        iconColor: kPrimaryColor,
                        icon: Icons.info);
                    Navigator.pushNamed(context, Profile.id);
                  } on PlatformException catch (e) {
                    buildCustomSnackbar(
                        messageText: e.message,
                        titleText: "Oops",
                        iconColor: Colors.red,
                        icon: Icons.error);
                  } finally {
                    bloc.loadingSink(false);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getImage(
      bool gallery, ProfileBloc bloc, BuildContext context) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;

    if (gallery) {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }
    Navigator.of(context).pop();

    if (pickedFile != null) {
      bloc.imageSink(File(pickedFile.path));
    } else {
      buildCustomSnackbar(
          messageText: 'No Image selected',
          titleText: "Oops",
          iconColor: Colors.red,
          icon: Icons.error);
    }
  }
}
