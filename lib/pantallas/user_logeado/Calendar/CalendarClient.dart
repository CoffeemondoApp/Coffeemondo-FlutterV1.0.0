import 'dart:convert';
import 'dart:io';

class CalendarClient {
  obtenerJSON(String email) async {
    var url =
        'https://www.googleapis.com/calendar/v3/calendars/$email/events?key=AIzaSyB-m9M_6qRLU1jAKaVSaX12puFKZWZ9s-Y';
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    var data = json.decode(responseBody);
    //Recorrer data y obtener la llave 'created'
    for (var i = 0; i < data['items'].length; i++) {
      var fecha_creacion = data['items'][i]['created'];
      var fecha_separada = fecha_creacion.split('T')[0].split('-');
      if (fecha_separada[0] == '2023') {
        print(fecha_separada);
      }
    }
  }
}
