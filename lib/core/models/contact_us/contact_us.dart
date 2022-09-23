import 'package:m3rady/core/utils/services/AppServices.dart';

class ContactUs {
  int id;
  String type;
  String name;
  String mobile;
  String whatsappMobile;
  String? email;
  String message;

  ContactUs({
    required this.id,
    required this.type,
    required this.name,
    required this.mobile,
    required this.whatsappMobile,
    this.email,
    required this.message,
  });

  /// Factory
  factory ContactUs.fromJson(Map<String, dynamic> data) {
    return ContactUs(
      id: data['id'] as int,
      type: data['type'] as String,
      name: data['name'] as String,
      mobile: data['mobile'] as String,
      whatsappMobile: data['whatsappMobile'] as String,
      email: data['email'],
      message: data['message'] as String,
    );
  }

  /// Create contact us
  static Future create({
    required String type,
    required String name,
    required String mobile,
    required String whatsappMobile,
    String? email,
    required String message,
  }) async {
    var request = await AppServices.createContactUs(
      type: type,
      name: name,
      mobile: mobile,
      whatsappMobile: whatsappMobile,
      email: email,
      message: message,
    );

    if (request['status'] == true) {
      return {
        'message': request['message'],
        'data': request['data'],
      };
    }

    return false;
  }
}
