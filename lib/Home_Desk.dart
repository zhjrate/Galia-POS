import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/auth.dart';
import 'package:denario/Dashboard/DailyDesk.dart';
import 'package:denario/Expenses/ExpensesDesk.dart';
import 'package:denario/Loading.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:denario/Models/PendingOrders.dart';
import 'package:denario/Models/Stats.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/No%20POS%20Sales/NoPOSDashboard.dart';
import 'package:denario/PnL/PnlDesk.dart';
import 'package:denario/Products/ProductsDesk.dart';
import 'package:denario/Schedule/ScheduleDesk.dart';
import 'package:denario/Stats/StatsDesk.dart';
import 'package:denario/Suppliers/SuppliersDesk.dart';
import 'package:denario/User%20Settings/UserSettings.dart';
import 'package:denario/Wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'POS/POS_Desk.dart';

class HomeDesk extends StatefulWidget {
  @override
  _HomeDeskState createState() => _HomeDeskState();
}

class _HomeDeskState extends State<HomeDesk> {
  final _auth = AuthService();
  int pageIndex = 0;
  bool showUserSettings = false;

  Widget screenNavigator(String screenName, IconData screenIcon, int index) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: Size(50, 50),
      ),
      onPressed: () {
        setState(() {
          pageIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon
            Icon(screenIcon, color: Colors.white, size: 25),
            SizedBox(height: 5),
            //Text
            Text(
              screenName,
              style: TextStyle(color: Colors.white, fontSize: 9),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  List<Widget> navigationBarItems;
  List<Widget> pageNavigators;
  //Roles and fields modifications
  ////User role
  ///Dueño => todo: POS, Daily, Gastos, Stats, Pnl | Productos, Proveedores, Clientes, Stock, Usuarios, Menu, Tienda
  ///Encargado => Sin PnL
  ///Mozo => Solo POS, Clientes, Stock
  ///Cajero => POS, Daily, Gastos, Productos, Proveedores, Clientes, Stock
  ///Contador => Solo Stats, PnL, Daily (ventas)
  ///Otro => Solo POS, Clientes, Stock
  ///
  ///Business Field => Inside POS widget
  ///Gastro => POS Variants (tables, counter | or products view)
  ///Profesionales => Sin POS, Dasboard con venta manual instead
  ///Tienda Minorista => POS de products view
  ///Otro => Sin POS, Dasboard con venta manual instead

  //Change Business Dialog
  void changeBusinessDialog(List<UserBusinessData> businesess, activeBusiness) {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                width: 450,
                height: MediaQuery.of(context).size.height * 0.6,
                padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Go back
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                          iconSize: 20.0),
                    ),
                    //Title
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Cambiar de negocio en pantalla",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: businesess.length,
                            itemBuilder: ((context, i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: (activeBusiness ==
                                            businesess[i].businessID)
                                        ? Colors.greenAccent
                                        : Colors.white,
                                    minimumSize: Size(50, 50),
                                  ),
                                  onPressed: () {
                                    if (activeBusiness !=
                                        businesess[i].businessID) {
                                      DatabaseService().changeActiveBusiness(
                                          businesess[i].businessID);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Wrapper()));
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 8),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${businesess[i].businessName}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'ID: ${businesess[i].businessID}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: (activeBusiness ==
                                                      businesess[i].businessID)
                                                  ? Colors.black54
                                                  : Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Rol: ${businesess[i].roleInBusiness}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: (activeBusiness ==
                                                      businesess[i].businessID)
                                                  ? Colors.black54
                                                  : Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }))),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void reloadApp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    final registerStatus = Provider.of<CashRegister>(context);
    final categoriesProvider = Provider.of<CategoryList>(context);
    final userProfile = Provider.of<UserData>(context);
    final userBusiness = Provider.of<BusinessProfile>(context);

    if (registerStatus == null ||
        categoriesProvider == null ||
        userProfile == null ||
        userBusiness == null) {
      return Loading();
    }

    final businessIndexOnProfile = userProfile.businesses.indexWhere(
        (element) => element.businessID == userProfile.activeBusiness);

    if (userProfile.businesses[businessIndexOnProfile].roleInBusiness ==
        'Dueñ@') {
      navigationBarItems = [
        screenNavigator(
            (userBusiness.businessField == 'Gastronómico' ||
                    userBusiness.businessField == 'Tienda Minorista')
                ? 'POS'
                : 'Inicio',
            (userBusiness.businessField == 'Gastronómico' ||
                    userBusiness.businessField == 'Tienda Minorista')
                ? Icons.blur_circular
                : Icons.home,
            0),
        SizedBox(height: 20),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? screenNavigator('Caja', Icons.fax, 1)
            : SizedBox(),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? SizedBox(height: 20)
            : SizedBox(),
        screenNavigator('Agenda', Icons.calendar_month_outlined, 2),
        SizedBox(height: 20),
        screenNavigator('Gastos', Icons.multiline_chart, 3),
        SizedBox(height: 20),
        screenNavigator('Productos', Icons.assignment, 4),
        SizedBox(height: 20),
        screenNavigator('Proveedores', Icons.account_box_outlined, 5),
        SizedBox(height: 20),
        screenNavigator('Stats', Icons.query_stats_outlined, 6),
        SizedBox(height: 20),
        screenNavigator('PnL', Icons.data_usage, 7)
      ];
      pageNavigators = [
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) {
            if (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista') {
              return POSDesk(firstCategory: categoriesProvider.categoryList[0]);
            } else {
              return NoPOSDashboard(userProfile.activeBusiness);
            }
          });
        }),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? Navigator(onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(builder: (context) => DailyDesk());
              })
            : Container(),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => ScheduleDesk());
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => ExpensesDesk('Dueñ@'));
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => ProductDesk(
                  userProfile.activeBusiness,
                  categoriesProvider.categoryList,
                  userBusiness.businessField,
                  reloadApp));
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => SuppliersDesk());
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => StatsDesk());
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => PnlDesk());
        }),
      ];
    } else if (userProfile.businesses[businessIndexOnProfile].roleInBusiness ==
        'Encargad@') {
      navigationBarItems = [
        screenNavigator(
            (userBusiness.businessField == 'Gastronómico' ||
                    userBusiness.businessField == 'Tienda Minorista')
                ? 'POS'
                : 'Inicio',
            (userBusiness.businessField == 'Gastronómico' ||
                    userBusiness.businessField == 'Tienda Minorista')
                ? Icons.blur_circular
                : Icons.home,
            0),
        SizedBox(height: 20),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? screenNavigator('Caja', Icons.fax, 1)
            : SizedBox(),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? SizedBox(height: 20)
            : SizedBox(),
        screenNavigator('Agenda', Icons.calendar_month_outlined, 2),
        SizedBox(height: 20),
        screenNavigator('Gastos', Icons.multiline_chart, 3),
        SizedBox(height: 20),
        screenNavigator('Productos', Icons.assignment, 4),
        SizedBox(height: 20),
        screenNavigator('Proveedores', Icons.account_box_outlined, 5),
        SizedBox(height: 20),
        screenNavigator('Stats', Icons.query_stats_outlined, 6),
      ];
      pageNavigators = [
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) {
            if (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista') {
              return POSDesk(firstCategory: categoriesProvider.categoryList[0]);
            } else {
              return NoPOSDashboard(userProfile.activeBusiness);
            }
          });
        }),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? Navigator(onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(builder: (context) => DailyDesk());
              })
            : Container(),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => ScheduleDesk());
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => ExpensesDesk('Encargad@'));
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => ProductDesk(
                  userProfile.activeBusiness,
                  categoriesProvider.categoryList,
                  userBusiness.businessField,
                  reloadApp));
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => SuppliersDesk());
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => StatsDesk());
        }),
      ];
    } else if (userProfile.businesses[businessIndexOnProfile].roleInBusiness ==
        'Cajer@') {
      navigationBarItems = [
        screenNavigator(
            (userBusiness.businessField == 'Gastronómico' ||
                    userBusiness.businessField == 'Tienda Minorista')
                ? 'POS'
                : 'Inicio',
            (userBusiness.businessField == 'Gastronómico' ||
                    userBusiness.businessField == 'Tienda Minorista')
                ? Icons.blur_circular
                : Icons.home,
            0),
        SizedBox(height: 20),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? screenNavigator('Caja', Icons.fax, 1)
            : SizedBox(),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? SizedBox(height: 20)
            : SizedBox(),
        screenNavigator('Agenda', Icons.calendar_month_outlined, 2),
        SizedBox(height: 20),
        screenNavigator('Gastos', Icons.multiline_chart, 3),
      ];
      pageNavigators = [
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) {
            if (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista') {
              return POSDesk(firstCategory: categoriesProvider.categoryList[0]);
            } else {
              return NoPOSDashboard(userProfile.activeBusiness);
            }
          });
        }),
        (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista')
            ? Navigator(onGenerateRoute: (routeSettings) {
                return MaterialPageRoute(builder: (context) => DailyDesk());
              })
            : Container(),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => ScheduleDesk());
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) => ExpensesDesk('Cajer@'));
        }),
      ];
    } else if (userProfile.businesses[businessIndexOnProfile].roleInBusiness ==
        'Contador(a)') {
      navigationBarItems = [
        screenNavigator('Stats', Icons.query_stats_outlined, 1),
        SizedBox(height: 20),
        screenNavigator('PnL', Icons.data_usage, 2),
      ];
      pageNavigators = [
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => StatsDesk());
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => PnlDesk());
        }),
      ];
    } else if (userProfile.businesses[businessIndexOnProfile].roleInBusiness ==
            'Moz@' ||
        userProfile.businesses[businessIndexOnProfile].roleInBusiness ==
            'Otro') {
      navigationBarItems = [
        screenNavigator(
            (userBusiness.businessField == 'Gastronómico' ||
                    userBusiness.businessField == 'Tienda Minorista')
                ? 'POS'
                : 'Inicio',
            (userBusiness.businessField == 'Gastronómico' ||
                    userBusiness.businessField == 'Tienda Minorista')
                ? Icons.blur_circular
                : Icons.home,
            0),
        SizedBox(height: 20),
        screenNavigator('Agenda', Icons.calendar_month_outlined, 1),
      ];
      pageNavigators = [
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) {
            if (userBusiness.businessField == 'Gastronómico' ||
                userBusiness.businessField == 'Tienda Minorista') {
              return POSDesk(firstCategory: categoriesProvider.categoryList[0]);
            } else {
              return NoPOSDashboard(userProfile.activeBusiness);
            }
          });
        }),
        Navigator(onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(builder: (context) => ScheduleDesk());
        }),
      ];
    }
    return MultiProvider(
      providers: [
        StreamProvider<CategoryList>.value(
            initialData: null,
            value:
                DatabaseService().categoriesList(userProfile.activeBusiness)),
        StreamProvider<HighLevelMapping>.value(
            initialData: null,
            value:
                DatabaseService().highLevelMapping(userProfile.activeBusiness)),
        StreamProvider<DailyTransactions>.value(
            initialData: null,
            catchError: (_, err) => null,
            value: DatabaseService().dailyTransactions(
                userProfile.activeBusiness, registerStatus.registerName)),
        StreamProvider<MonthlyStats>.value(
            initialData: null,
            value: DatabaseService()
                .monthlyStatsfromSnapshot(userProfile.activeBusiness)),
        StreamProvider<List<DailyTransactions>>.value(
            initialData: null,
            value: DatabaseService()
                .dailyTransactionsList(userProfile.activeBusiness)),
        StreamProvider<List<PendingOrders>>.value(
            initialData: null,
            value:
                DatabaseService().pendingOrderList(userProfile.activeBusiness)),
        StreamProvider<AccountsList>.value(
            initialData: null,
            value: DatabaseService().accountsList(userProfile.activeBusiness))
      ],
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Center(
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/Denario Tag.png'))),
              ),
            ),
            leading: showUserSettings
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showUserSettings = false;
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 16,
                    ))
                : Container(),
            actions: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: PopupMenuButton<int>(
                      tooltip: 'Perfil',
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: NetworkImage(userProfile.profileImage),
                                  fit: BoxFit.cover))),
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            setState(() {
                              showUserSettings = true;
                            });
                            break;
                          case 1:
                            changeBusinessDialog(userProfile.businesses,
                                userProfile.activeBusiness);
                            break;
                          case 2:
                            _auth.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wrapper()));
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                            //Settings
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  SizedBox(width: 10),
                                  Text("Configuración")
                                ],
                              ),
                            ),
                            //Change Business
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.swap_horiz_outlined,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  SizedBox(width: 10),
                                  Text("Cambiar de negocio")
                                ],
                              ),
                            ),
                            //Exit
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.exit_to_app,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  SizedBox(width: 10),
                                  Text("Salir")
                                ],
                              ),
                            ),
                          ]))
            ],
          ),
          body: showUserSettings
              ? UserSettings()
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Navigation Bar
                      Container(
                          color: Colors.black87,
                          height: double.infinity,
                          width: 75,
                          child: SingleChildScrollView(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 5),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: navigationBarItems)),
                          )),
                      //Dynamic Body
                      Expanded(
                        child: Container(
                            child: IndexedStack(
                                index: pageIndex, children: pageNavigators)),
                      )
                    ],
                  ),
                )),
    );
  }
}
