import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/PendingOrders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class OrderAlert extends StatefulWidget {
  final List<PendingOrders> pendingOrders;
  final String businessID;
  const OrderAlert(this.pendingOrders, this.businessID, {Key key})
      : super(key: key);

  @override
  State<OrderAlert> createState() => _OrderAlertState();
}

class _OrderAlertState extends State<OrderAlert> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  AudioPlayer audioPlayer = AudioPlayer();
  // PlayerState audioPlayerState = PlayerState.playing;
  AudioCache audioCache;
  String audioPath = 'sounds/service-bell-ring.mp3';

  @override
  void initState() {
    super.initState();
    setAudio();
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    final player = AudioCache(prefix: 'sounds/');
    final url = await player.load('service-bell-ring.mp3');

    audioPlayer.setSourceUrl(
      url.path,
    );

    audioPlayer.resume();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    // audioCache.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      alignment: Alignment.center,
      child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          width: 750,
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Nombre
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text('${widget.pendingOrders.last.orderName}'),
                  SizedBox(width: 50),
                  Icon(
                    Icons.phone,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text('${widget.pendingOrders.last.phone}'),
                  IconButton(
                      tooltip: 'Copiar',
                      iconSize: 14,
                      splashRadius: 15,
                      onPressed: () async {
                        Clipboard.setData(ClipboardData(
                                text: '${widget.pendingOrders.last.phone}'))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Número de celular copiado al clipboard")));
                        });
                      },
                      icon: Icon(Icons.copy)),
                  SizedBox(width: 50),
                  Icon(
                    Icons.pin_drop,
                    size: 18,
                  ),
                  SizedBox(width: 5),
                  Text('${widget.pendingOrders.last.address}'),
                  Spacer(),
                  Text(
                    '1/${widget.pendingOrders.length}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 15),
              //Payment type
              Text('Pago: ${widget.pendingOrders.last.paymentType}'),
              SizedBox(height: 15),
              Divider(thickness: 0.5, indent: 10, endIndent: 10),
              SizedBox(height: 15),
              //Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text(
                      'Pedido',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                    ),
                    SizedBox(width: 20),
                    Text(
                      '(${widget.pendingOrders.last.orderDetail.length} items)',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.pendingOrders.last.orderDetail.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.pendingOrders.last.orderDetail[i]['Quantity']} x',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(width: 25),
                              Text(
                                '${widget.pendingOrders.last.orderDetail[i]['Name']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                '${formatCurrency.format(widget.pendingOrders.last.orderDetail[i]['Total Price'])}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              )),
              SizedBox(height: 15),
              Divider(thickness: 0.5, indent: 10, endIndent: 10),
              SizedBox(height: 15),
              //Total
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //Total
                    Text(
                      'Total: ${formatCurrency.format(widget.pendingOrders.last.total)}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              //Boton de aceptar (lo guarda en saved, elimina de pendientes)
              //Boton de rechazar (lo elimina)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Boton rechazar
                  Container(
                    height: 50,
                    width: 250,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  color: Colors.white,
                                  width: 750,
                                  height: 600,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 450,
                                          child: Text(
                                            'Si eliminas este pedido recuerda contactar al cliente para avisarle. Puedes copiar el número de celular acá',
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                                '${widget.pendingOrders.last.phone}'),
                                            IconButton(
                                                tooltip: 'Copiar',
                                                iconSize: 14,
                                                splashRadius: 15,
                                                onPressed: () async {
                                                  Clipboard.setData(ClipboardData(
                                                          text:
                                                              '${widget.pendingOrders.last.phone}'))
                                                      .then((_) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Número de celular copiado al clipboard")));
                                                  });
                                                },
                                                icon: Icon(Icons.copy)),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            //Volver
                                            Container(
                                              height: 50,
                                              width: 250,
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: Colors.black,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text('Volver'),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            //Rechazar
                                            Container(
                                              height: 50,
                                              width: 250,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black,
                                                  foregroundColor: Colors.black,
                                                ),
                                                onPressed: () {
                                                  DatabaseService()
                                                      .deletePendingOrder(
                                                          widget.businessID,
                                                          widget.pendingOrders
                                                              .last.docID);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Rechazar',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]),
                                ),
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Rechazar'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  //Boton aceptar
                  Container(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onPressed: () {
                          DatabaseService().saveOrder(
                              widget.businessID,
                              DateTime.now().toString(),
                              widget.pendingOrders.last.total,
                              0,
                              0,
                              widget.pendingOrders.last.total,
                              widget.pendingOrders.last.orderDetail,
                              widget.pendingOrders.last.orderName,
                              widget.pendingOrders.last.paymentType,
                              Colors
                                  .primaries[
                                      Random().nextInt(Colors.primaries.length)]
                                  .value,
                              false,
                              'Delivery',
                              {
                                'Name': widget.pendingOrders.last.orderName,
                                'Address': widget.pendingOrders.last.address,
                                'Phone': widget.pendingOrders.last.phone,
                                'email': '',
                              });
                          DatabaseService().deletePendingOrder(
                              widget.businessID,
                              widget.pendingOrders.last.docID);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Center(
                            child: Text('Aceptar'),
                          ),
                        )),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
