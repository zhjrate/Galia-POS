import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/User.dart';
import 'package:flutter/material.dart';

class ManageUsersDialog extends StatefulWidget {
  final UserData userProfile;
  final int index;
  ManageUsersDialog(this.userProfile, this.index);

  @override
  State<ManageUsersDialog> createState() => _ManageUsersDialogState();
}

class _ManageUsersDialogState extends State<ManageUsersDialog> {
  String rol = '';
  bool madeChanges = false;

  @override
  void initState() {
    rol = widget.userProfile.businesses[widget.index].roleInBusiness;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width * 0.35,
          constraints: BoxConstraints(minWidth: 400),
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Close
                Container(
                  alignment: Alignment(1.0, 0.0),
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                      iconSize: 20.0),
                ),
                SizedBox(height: 10),
                //Pic
                Row(
                  children: [
                    //Pic
                    Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.black38)),
                    SizedBox(width: 12),
                    //Name
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Nme
                        Text('${widget.userProfile.name}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        //UID
                        Text(
                          '${widget.userProfile.uid}',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        //ROL
                        Row(
                          children: [
                            Text(rol),
                            SizedBox(width: 5),
                            PopupMenuButton<int>(
                                tooltip: 'Editar Rol',
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                onSelected: (value) {
                                  switch (value) {
                                    case 0:
                                      setState(() {
                                        rol = 'Dueñ@';
                                        madeChanges = true;
                                      });
                                      break;
                                    case 1:
                                      setState(() {
                                        rol = 'Encargad@';
                                        madeChanges = true;
                                      });
                                      break;
                                    case 2:
                                      setState(() {
                                        rol = 'Moz@';
                                        madeChanges = true;
                                      });
                                      break;
                                    case 3:
                                      setState(() {
                                        rol = 'Cajero(a)';
                                        madeChanges = true;
                                      });
                                      break;
                                    case 4:
                                      setState(() {
                                        rol = 'Contador(a)';
                                        madeChanges = true;
                                      });
                                      break;
                                    case 5:
                                      setState(() {
                                        rol = 'Otro';
                                        madeChanges = true;
                                      });
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                      PopupMenuItem<int>(
                                        value: 0,
                                        child: Text("Dueñ@"),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 1,
                                        child: Text("Encargad@"),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 2,
                                        child: Text("Moz@"),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 3,
                                        child: Text("Cajer@"),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 4,
                                        child: Text("Contador(a)"),
                                      ),
                                      PopupMenuItem<int>(
                                        value: 5,
                                        child: Text("Otro"),
                                      ),
                                    ])
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                Spacer(),
                //Buttons, cancel, save (if role is changed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 35,
                        width: 150,
                        child: Center(
                          child: Text(
                            'Calcelar',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor:
                            madeChanges ? Colors.black : Colors.grey[350],
                      ),
                      onPressed: () {
                        if (madeChanges) {
                          DatabaseService().deleteUserBusiness({
                            'Business ID': widget.userProfile
                                .businesses[widget.index].businessID,
                            'Business Name': widget.userProfile
                                .businesses[widget.index].businessName,
                            'Business Rol': widget.userProfile
                                .businesses[widget.index].roleInBusiness,
                            'Table View': widget
                                .userProfile.businesses[widget.index].tableView
                          }, widget.userProfile.uid).then((value) {
                            DatabaseService().updateUserBusinessProfile({
                              'Business ID': widget.userProfile
                                  .businesses[widget.index].businessID,
                              'Business Name': widget.userProfile
                                  .businesses[widget.index].businessName,
                              'Business Rol': rol,
                              'Table View': widget.userProfile
                                  .businesses[widget.index].tableView
                            }, widget.userProfile.uid);
                          });

                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        height: 35,
                        width: 150,
                        child: Center(
                          child: Text(
                            'Guardar',
                            style: TextStyle(
                                color:
                                    madeChanges ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
