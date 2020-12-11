import 'dart:convert';

import 'package:book_app_demo/const_values.dart';
import 'package:book_app_demo/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const headers = {"Accept": "application/json"};

  List _data;

  Future fetchUserDetials() async {
    final response = await http.get(
      userApiRequest,
      headers: headers,
    );

    List<UserModel> userDetails = List();

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      _data = responseBody['data'];

      _data.forEach((user) {
        int id = user['id'];
        String email = user['email'];
        String firstName = user['first_name'];
        String lastName = user['last_name'];
        String avater = user['avatar'];

        userDetails.add(UserModel(
          uid: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          avater: avater,
        ));
      });
    } else if (response.statusCode == 500) {
      logger.d("Something went wrong ${response.body}");
    } else {
      logger.i("No response received......");
    }

    return userDetails;
  }
}
