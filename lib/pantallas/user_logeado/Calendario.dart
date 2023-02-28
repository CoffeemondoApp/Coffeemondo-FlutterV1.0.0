import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffeemondo/pantallas/user_logeado/Calendar/Cliente.dart';
import 'package:coffeemondo/pantallas/user_logeado/EventoCalendario.dart';
import 'package:coffeemondo/pantallas/user_logeado/eventos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../firebase/autenticacion.dart';

class CalendarioPage extends StatefulWidget {
  final String fecha;
  const CalendarioPage(this.fecha, {super.key});

  @override
  CalendarioApp createState() => CalendarioApp();
}

String email = '';
bool eventos_generados = false;

class CalendarioApp extends State<CalendarioPage> {
  void _getEmailUsuario() async {
    User? user = Auth().currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        email = userData.data()!['email'];
      });
    });
  }

  late Map<DateTime, List<EventoCalendario>> EventoSeleccionado;

  void initState() {
    EventoSeleccionado = {};
    _getEmailUsuario();

    super.initState();
  }

  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();

  List<EventoCalendario> _obtenerEventosDelDia(DateTime dia) {
    return EventoSeleccionado[dia] ?? [];
  }

  void _agregarEvento(DateTime dia, titulo) {
    if (EventoSeleccionado[dia] != null) {
      EventoSeleccionado[dia]!.add(
        EventoCalendario(titulo: titulo),
      );
    } else {
      EventoSeleccionado[dia] = [EventoCalendario(titulo: titulo)];
    }
  }

  dynamic _obtenerEventosCliente() async {
    var eventos_usuario = await Cliente().obtenerJSON(email);
    print("Eventos cliente:");
    print(eventos_usuario);
    return eventos_usuario;
  }

  void _generarEventosCliente(dynamic eventos) async {
    //recorrer future<dynamic> eventos
    for (var evento in await eventos) {
      var string_dateTime = evento['fechaInicio'] + 'Z';

      _agregarEvento(DateTime.parse(string_dateTime), evento['titulo']);
    }
    eventos_generados = true;
  }

  @override
  Widget build(BuildContext context) {
    var eventos_cliente = _obtenerEventosCliente();

    if (!eventos_generados) {
      _generarEventosCliente(eventos_cliente);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: morado,
        title: Text('Calendario de CoffeeMondo'),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'es_CL',
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: CalendarFormat.month,

            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _obtenerEventosDelDia,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: morado,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: naranja,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              markerDecoration: BoxDecoration(
                color: naranja,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          ..._obtenerEventosDelDia(selectedDay)
              .map((EventoCalendario event) => Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    margin: EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.8),
                        borderRadius: BorderRadius.circular(12.0),
                        color: morado),
                    child: Column(children: [
                      Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Text(
                            event.titulo,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ))
                    ]),
                  )),
          GestureDetector(
            child: Container(
              child: Text('Subir evento'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}
