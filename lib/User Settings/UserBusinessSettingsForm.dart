import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/User%20Settings/AddUserDialog.dart';
import 'package:denario/User%20Settings/UserCard.dart';
import 'package:denario/Wrapper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserBusinessSettingsForm extends StatefulWidget {
  final String rol;
  UserBusinessSettingsForm(this.rol);

  @override
  State<UserBusinessSettingsForm> createState() =>
      _UserBusinessSettingsFormState();
}

class _UserBusinessSettingsFormState extends State<UserBusinessSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final controller = PageController();

  final FocusNode _businessNameNode = FocusNode();
  final FocusNode _businessLocationNode = FocusNode();
  final FocusNode _businessSizeNode = FocusNode();

  String businessName = "";
  List businessFieldList = [
    'Gastronómico', //Vista de Mesas/Mostrador + Botón de venta manual
    'Servicios Profesionales', //Solo boton de venta manual
    'Minorista', //Solo venta de mostrador + boton de venta manual
    'Otro' //Solo boton de venta manual
  ];
  String businessLocation = "";
  int businessSize = 0;
  String businessImage = '';

  Uint8List webImage = Uint8List(8);
  String downloadUrl;
  bool changedImage = false;

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

  Future uploadPic(businessID) async {
    ////Upload to Clod Storage

    String fileName = 'Business Images/' + businessID + '.png';
    var ref = FirebaseStorage.instance.ref().child(fileName);

    TaskSnapshot uploadTask = await ref.putData(webImage);

    ///Save to Firestore
    if (uploadTask.state == TaskState.success) {
      downloadUrl = await uploadTask.ref.getDownloadURL();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userBusiness = Provider.of<BusinessProfile>(context);

    if (userBusiness == null) {
      return Container();
    }

    return PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          //Business Info
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Fixed Data
                Container(
                  constraints: BoxConstraints(
                      maxHeight: 600,
                      maxWidth: 200,
                      minHeight: 400,
                      minWidth: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Pic
                      Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: (changedImage)
                                      ? Image.memory(
                                          webImage,
                                          fit: BoxFit.cover,
                                        ).image
                                      : NetworkImage(
                                          userBusiness.businessImage),
                                  fit: BoxFit.cover))),
                      SizedBox(height: 5),
                      TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.black),
                        onPressed: getImage,
                        child: Container(
                          height: 35,
                          width: 60,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 2),
                          child: Center(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 12,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Editar',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      //ID
                      SizedBox(height: 15),
                      Text(
                        'ID del Negocio',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${userBusiness.businessID}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      //Rubro
                      SizedBox(height: 25),
                      Text(
                        'Rubro del negocio',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${userBusiness.businessField}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      //Mi Rol
                      SizedBox(height: 25),
                      Text(
                        'Mi rol en el negocio',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        '${widget.rol}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                //Form
                Container(
                  constraints: BoxConstraints(
                      minHeight: 300,
                      minWidth: 400,
                      maxHeight: 300,
                      maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5),
                        //Nombre
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          validator: (val) =>
                              val.isEmpty ? "Agrega un nombre" : null,
                          autofocus: true,
                          readOnly: (widget.rol == 'Dueñ@') ? false : true,
                          cursorColor: Colors.grey,
                          cursorHeight: 25,
                          focusNode: _businessNameNode,
                          initialValue: userBusiness.businessName,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text('Nombre del negocio'),
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            prefixIcon: Icon(
                              Icons.store,
                              color: Colors.grey,
                            ),
                            errorStyle: TextStyle(
                                color: Colors.redAccent[700], fontSize: 12),
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
                            _businessNameNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_businessLocationNode);
                          },
                          onChanged: (val) {
                            setState(() => businessName = val);
                          },
                        ),
                        //Ubicacion
                        SizedBox(height: 25),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          validator: (val) => val.isEmpty
                              ? "Agrega una ubicación válida"
                              : null,
                          readOnly: (widget.rol == 'Dueñ@') ? false : true,
                          cursorColor: Colors.grey,
                          cursorHeight: 25,
                          focusNode: _businessLocationNode,
                          initialValue: userBusiness.businessLocation,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text('Ubicación'),
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            prefixIcon: Icon(
                              Icons.location_pin,
                              color: Colors.grey,
                            ),
                            errorStyle: TextStyle(
                                color: Colors.redAccent[700], fontSize: 12),
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
                            _businessLocationNode.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_businessSizeNode);
                          },
                          onChanged: (val) {
                            setState(() => businessLocation = val);
                          },
                        ),
                        //Size
                        SizedBox(height: 25),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (val) =>
                              val.isEmpty ? "Agrega un número válido" : null,
                          readOnly: (widget.rol == 'Dueñ@') ? false : true,
                          cursorColor: Colors.grey,
                          cursorHeight: 25,
                          focusNode: _businessSizeNode,
                          initialValue: userBusiness.businessSize.toString(),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text(
                                'Número de personas trabajando en el negocio'),
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            errorStyle: TextStyle(
                                color: Colors.redAccent[700], fontSize: 12),
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
                            _businessSizeNode.unfocus();
                          },
                          onChanged: (val) {
                            setState(() => businessSize = int.parse(val));
                          },
                        ),
                        //Button
                        SizedBox(height: 35),
                        (widget.rol == 'Dueñ@')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.grey,
                                        backgroundColor: Colors.black),
                                    onPressed: () {
                                      if (businessName == '') {
                                        businessName =
                                            userBusiness.businessName;
                                      }
                                      if (businessLocation == '') {
                                        businessLocation =
                                            userBusiness.businessLocation;
                                      }
                                      if (businessImage == '') {
                                        businessImage =
                                            userBusiness.businessName;
                                      }
                                      if (changedImage) {
                                        uploadPic(userBusiness.businessID).then(
                                            (value) => DatabaseService()
                                                    .updateUserBusiness(
                                                  userBusiness.businessID,
                                                  businessName,
                                                  businessLocation,
                                                  businessSize,
                                                  downloadUrl,
                                                ));
                                      } else {
                                        DatabaseService().updateUserBusiness(
                                          userBusiness.businessID,
                                          businessName,
                                          businessLocation,
                                          businessSize,
                                          userBusiness.businessImage,
                                        );
                                      }

                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Wrapper()));
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 10),
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
                                  SizedBox(width: 15),
                                  OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.grey),
                                    onPressed: () {
                                      controller.nextPage(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeIn);
                                      //Crear usuario (auth + users db)
                                      //Eliminar usuario (remover el negocio de su lista), quitar el UID del negocio
                                      //Cambiar de rol del usuario
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (context) {
                                      //       return ManageUsersDialog(
                                      //           userBusiness.businessUsers);
                                      //     });
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 10),
                                      child: Center(
                                        child: Text(
                                          'Gestionar Usuarios',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                //Manage users and save
              ]),
          //Manage users
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(children: [
              //Botones (agregar usuario (auth + users db), modifical rol, eliminar (remover el negocio de su lista), quitar el UID del negocio)
              // Padding(
              //     padding: EdgeInsets.only(bottom: 20),
              //     child: Row(children: [
              //       //Crear Usurario
              //       Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0),
              //         child: TextButton(
              //           style: ElevatedButton.styleFrom(
              //             foregroundColor: Colors.black,
              //             backgroundColor: Colors.transparent,
              //             minimumSize: Size(50, 50),
              //           ),
              //           onPressed: () {},
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: 5.0, horizontal: 8),
              //             child: Row(
              //               children: [
              //                 Icon(
              //                   Icons.person_add,
              //                   size: 16,
              //                   color: Colors.black,
              //                 ),
              //                 SizedBox(width: 8),
              //                 Text(
              //                   'Crear Usurario',
              //                   textAlign: TextAlign.start,
              //                   style: TextStyle(
              //                       color: Colors.black,
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //       //Cambiar rol de usuario
              //       Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0),
              //         child: TextButton(
              //           style: ElevatedButton.styleFrom(
              //             foregroundColor: Colors.black,
              //             backgroundColor: Colors.transparent,
              //             minimumSize: Size(50, 50),
              //           ),
              //           onPressed: () {},
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: 5.0, horizontal: 8),
              //             child: Row(
              //               children: [
              //                 Icon(
              //                   Icons.person_pin,
              //                   size: 16,
              //                   color: Colors.black,
              //                 ),
              //                 SizedBox(width: 8),
              //                 Text(
              //                   'Cambiar Rol',
              //                   textAlign: TextAlign.start,
              //                   style: TextStyle(
              //                       color: Colors.black,
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //       //Eliminar usuario
              //       Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0),
              //         child: TextButton(
              //           style: ElevatedButton.styleFrom(
              //             foregroundColor: Colors.black,
              //             backgroundColor: Colors.transparent,
              //             minimumSize: Size(50, 50),
              //           ),
              //           onPressed: () {},
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: 5.0, horizontal: 8),
              //             child: Row(
              //               children: [
              //                 Icon(
              //                   Icons.person_remove,
              //                   size: 16,
              //                   color: Colors.black,
              //                 ),
              //                 SizedBox(width: 8),
              //                 Text(
              //                   'Eliminar Usuario',
              //                   textAlign: TextAlign.start,
              //                   style: TextStyle(
              //                       color: Colors.black,
              //                       fontSize: 14,
              //                       fontWeight: FontWeight.w400),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ])),
              // //Lista => Titulos (Nombre, email, rol), seleccionable, se activan los botones de arriba
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Titles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Pic
                      Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              image: DecorationImage(
                                  image: NetworkImage(''), fit: BoxFit.cover))),
                      SizedBox(width: 10),
                      //Name
                      Container(
                        width: 200,
                        child: Center(
                            child: Text(
                          'Nombre',
                          style: TextStyle(color: Colors.grey),
                        )),
                      ),
                      SizedBox(width: 10),
                      //EMAIL
                      Container(
                        width: 200,
                        child: Center(
                            child: Text('Teléfono',
                                style: TextStyle(color: Colors.grey))),
                      ),
                      SizedBox(width: 10),
                      //Rol
                      Container(
                        width: 200,
                        child: Center(
                            child: Text('Rol del usuario',
                                style: TextStyle(color: Colors.grey))),
                      ),
                      //Button to Add User
                      OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AddUserDialog(userBusiness.businessID,
                                    userBusiness.businessName);
                              });
                        },
                        child: Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              //Icon
                              Icon(Icons.person_add,
                                  size: 16, color: Colors.black),
                              SizedBox(width: 10),
                              //Name
                              Text(
                                'Agregar nuevo usuario',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  //List
                  Container(
                    height: 400,
                    width: 750,
                    child: ListView.builder(
                        itemCount: userBusiness.businessUsers.length,
                        itemBuilder: (context, i) {
                          return StreamProvider<UserData>.value(
                              initialData: null,
                              value: DatabaseService()
                                  .userProfile(userBusiness.businessUsers[i]),
                              child: UserCard(userBusiness.businessID));
                        }),
                  )
                ],
              )
            ]),
          )
        ]);
  }
}
