import 'dart:convert';
import 'dart:io';

class Cliente {
  //El atributo fecha es la fecha obtenida del evento
  //el atributo anio es el año en el que se quiere filtrar la info
  //el atributo tipo es una forma de saber si es una fecha ingresada de una forma u otra
  bool obtenerFecha(String fecha, String anio, int tipo) {
    var fecha_anio;
    if (tipo == 1) {
      var fecha_separada = fecha.split('T');
      var fecha_separada2 = fecha_separada[0].split('-');
      fecha_anio = fecha_separada2[0];
    } else {
      var fecha_separada = fecha.split('-');
      fecha_anio = fecha_separada[0];
    }

    if (fecha_anio == anio) {
      return true;
    }
    return false;
  }

  String traducirFecha(String fecha, int tipo) {
    var fecha_traducida;
    if (tipo == 1) {
      var fecha_separada1 = fecha.split('T');
      var fecha_separada2 = fecha_separada1[1].split('-');
      fecha_traducida = fecha_separada1[0] + ' ' + '00:00:00';
    } else {
      fecha_traducida = fecha + ' 00:00:00';
    }
    return fecha_traducida;
  }

  obtenerJSON(String email) async {
    var Eventos = [];
    var url =
        'https://www.googleapis.com/calendar/v3/calendars/$email/events?key=AIzaSyB-m9M_6qRLU1jAKaVSaX12puFKZWZ9s-Y';
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    var data = json.decode(responseBody);
    //Recorrer data y obtener la llave 'created'
    for (var i = 0; i < data['items'].length; i++) {
      if (data['items'][i]['start']['dateTime'] != null) {
        var is2023 =
            obtenerFecha(data['items'][i]['start']['dateTime'], '2023', 1);

        if (is2023) {
          if (data['items'][i]['summary'] == null) {
            data['items'][i]['summary'] = 'Sin título';
          }
          print(data['items'][i]['start']['dateTime']);
          Eventos.add({
            'fechaInicio':
                traducirFecha(data['items'][i]['start']['dateTime'], 1),
            'fechaFin': traducirFecha(data['items'][i]['end']['dateTime'], 1),
            'titulo': data['items'][i]['summary']
          });
        }
      } else if (data['items'][i]['start']['date'] != null) {
        var is2023 = obtenerFecha(data['items'][i]['start']['date'], '2023', 2);
        if (is2023) {
          if (data['items'][i]['summary'] == null) {
            data['items'][i]['summary'] = 'Sin título';
          }

          Eventos.add({
            'fechaInicio': traducirFecha(data['items'][i]['start']['date'], 2),
            'fechaFin': traducirFecha(data['items'][i]['end']['date'], 2),
            'titulo': data['items'][i]['summary']
          });
        }
      }
    }
    return Eventos;
  }
}
