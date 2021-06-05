import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
      'AAAAI2sePQg:APA91bHqOXZaM13RDWPrySBAIg-vOr-kIO4RdbaDKiwAS808tKS5DLVKfymFKBB5WczNpn_8mhCmSLTIdCmtbdiH5BHlJkYfurqbriTbMASgDTVV2iRdqROJp_YyH7FpSpwv7HjulLIn';


  static Future<Response> sendTo({
    @required String title,
    @required String body,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '/topics/all',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
