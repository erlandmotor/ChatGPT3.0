import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HistoryImageController extends GetxController {
  RxList Data = [].obs;
  DeleteOne({required Map k}) async {
    Map<String, String> h = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    http.Response response = await http.post(
      Uri.parse(
          "https://unextenuated-flower.000webhostapp.com/chatGpt/Api/delect_image_one_api.php"),
      body: k,
      headers: h,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data;
    }
  }

  DeleteAll({required Map k}) async {
    Map<String, String> h = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    http.Response response = await http.post(
      Uri.parse(
          "https://unextenuated-flower.000webhostapp.com/chatGpt/Api/delete_image_all_api.php"),
      body: k,
      headers: h,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return data;
    }
  }

  Updateall({required Map k}) async {
    String api =
        "https://unextenuated-flower.000webhostapp.com/chatGpt/Api/update_image_api.php";

    http.MultipartRequest request =
        await http.MultipartRequest("POST", Uri.parse(api));
    print("Parth");
    // request.fields['U_Id'] = k['U_Id'];
    request.fields['I_Id'] = k['I_Id'];

    request.files.add(http.MultipartFile.fromBytes("image", k['Image'],
        filename: k['ImageName']));

    http.StreamedResponse res = await request.send();

    print("Parth");
    if (res.statusCode == 200) {
      print("Parth");
    }
  }

  getImage({required Map k}) async {
    Map<String, String> h = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    http.Response response = await http.post(
      Uri.parse(
          "https://unextenuated-flower.000webhostapp.com/chatGpt/Api/get_image_api.php"),
      body: k,
      headers: h,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      Data.value = data;
      return data;
    }
  }
}
