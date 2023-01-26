import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/auth.dart';
import 'package:denario/Wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileSettings extends StatefulWidget {
  final String userName;
  final int userPhone;
  final String profileImage;
  final String uid;
  UserProfileSettings(
      this.userName, this.userPhone, this.profileImage, this.uid);

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameNode = FocusNode();
  final FocusNode _tlfNode = FocusNode();

  String name = "";
  int phone = 0;
  String pic = '';
  bool changedImage = false;

  Uint8List webImage = Uint8List(8);
  String downloadUrl;

  Future getImage() async {
    XFile selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      Uint8List uploadFile = await selectedImage.readAsBytes();
      setState(() {
        webImage = uploadFile;
        changedImage = true;
      });
    }
  }

  Future uploadPic() async {
    ////Upload to Clod Storage
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    String fileName = 'Profile Images/' + uid + '.png';
    var ref = FirebaseStorage.instance.ref().child(fileName);

    TaskSnapshot uploadTask = await ref.putData(webImage);

    ///Save to Firestore
    if (uploadTask.state == TaskState.success) {
      downloadUrl = await uploadTask.ref.getDownloadURL();
    }
  }

  @override
  void initState() {
    pic = widget.profileImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Title
          Text(
            'Información Personal',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          //Pic
          Container(
              height: 100,
              width: 220,
              child: (webImage.length == 8)
                  ? Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey,
                          image: DecorationImage(
                              image: NetworkImage(pic), fit: BoxFit.scaleDown)))
                  : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.grey,
                          image: DecorationImage(
                              image: Image.memory(
                            webImage,
                            fit: BoxFit.scaleDown,
                          ).image)),
                    )),
          // SizedBox(width: 10),
          //Button
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            onPressed: getImage,
            child: Container(
              height: 40,
              width: 100,
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
              child: Center(
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Editar',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ]),
              ),
            ),
          ),

          SizedBox(width: 20),
          //Form
          Container(
            width: 400,
            height: 200,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Nombre
                  TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    validator: (val) => val.isEmpty ? "Agrega un nombre" : null,
                    autofocus: true,
                    cursorColor: Colors.grey,
                    cursorHeight: 25,
                    focusNode: _nameNode,
                    initialValue: widget.userName,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Text('Nombre'),
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                      ),
                      errorStyle:
                          TextStyle(color: Colors.redAccent[700], fontSize: 12),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (term) {
                      _nameNode.unfocus();
                      FocusScope.of(context).requestFocus(_tlfNode);
                    },
                    onChanged: (val) {
                      setState(() => name = val);
                    },
                  ),
                  //Whatsapp
                  SizedBox(height: 25),
                  TextFormField(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (val) => val.isEmpty
                        ? "Agrega un celular válido"
                        : (val.length == 10)
                            ? null
                            : "El número de celular debe tener 10 caracteres",
                    cursorColor: Colors.grey,
                    cursorHeight: 25,
                    focusNode: _tlfNode,
                    initialValue: widget.userPhone.toString(),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Text('Teléfono'),
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey,
                      ),
                      errorStyle:
                          TextStyle(color: Colors.redAccent[700], fontSize: 12),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                        borderSide: new BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (term) {
                      _tlfNode.unfocus();
                    },
                    onChanged: (val) {
                      setState(() => phone = int.parse('11' + val));
                    },
                  ),
                  SizedBox(height: 25),
                  //UID
                  Text(
                    'UID: ${widget.uid}',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          //   ],
          // ),
          // ),
          //Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey, backgroundColor: Colors.black),
            onPressed: () {
              if (name == '') {
                name = widget.userName;
              }
              if (phone == 0) {
                phone = widget.userPhone;
              }
              if (changedImage) {
                uploadPic().then((value) => DatabaseService()
                    .updateUserProfile(name, phone, downloadUrl));
              } else {
                DatabaseService()
                    .updateUserProfile(name, phone, widget.profileImage);
                AuthService().updateUserData(name);
              }

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Wrapper()));
            },
            child: Container(
              width: 100,
              height: 40,
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
              child: Center(
                child: Text(
                  'Guardar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          //Reset email
          //Reset Password
        ],
      ),
    );
  }
}
