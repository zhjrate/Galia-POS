import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/ScheduledSales.dart';
import 'package:denario/Schedule/TasksList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DaysList extends StatelessWidget {
  final String activeBusiness;
  final String selectedFilter;
  final DateTime selectedDate;
  DaysList(this.activeBusiness, this.selectedFilter, this.selectedDate);
  final List<String> meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre'
  ];
  final List<String> diasDeLaSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${diasDeLaSemana[selectedDate.weekday - 1]}, ${selectedDate.day} ${meses[selectedDate.month - 1]}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            StreamProvider<List<ScheduledSales>>.value(
                initialData: null,
                value: DatabaseService()
                    .scheduledList(activeBusiness, selectedDate),
                child: TaskList(activeBusiness)),
          ],
        ));
  }
}
