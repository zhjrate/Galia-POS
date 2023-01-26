import 'package:denario/Models/User.dart';
import 'package:denario/User%20Settings/UserBusinessSettings.dart';
import 'package:denario/User%20Settings/UserProfileSettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  int activePage = 0;

  List settingsPages = ['Mi Perfil', 'Mis Negocios'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserData>(context);

    if (userProfile == null) {
      return Container();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Category selection
            Container(
              height: 50,
              width: double.infinity,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          minimumSize: Size(50, 50),
                        ),
                        onPressed: () {
                          setState(() {
                            activePage = i;
                            _controller.jumpToPage(i);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            width: 2,
                            color: (activePage == i)
                                ? Colors.black
                                : Colors.transparent,
                          ))),
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Center(
                            child: Text(
                              settingsPages[i],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20),
            //Pages
            Expanded(
                child: Container(
                    child: PageView(controller: _controller, children: [
              UserProfileSettings(userProfile.name, userProfile.phone,
                  userProfile.profileImage, userProfile.uid),
              UserBusinessSettings(userProfile.businesses),
            ]))),
          ],
        ),
      ),
    );
  }
}
