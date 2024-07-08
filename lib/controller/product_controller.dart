import 'dart:async';
import 'dart:convert';
import 'package:food_shopper/model/product_model.dart';
import 'package:http/http.dart' as http;

String timbuUrl =
    'https://api.timbu.cloud/products?organization_id=$OrgID&Appid=$AppID&Apikey=$APIkey';

String AppID = '1QYCHEMCD2A56XT';
// String APIkey = const String.fromEnvironment('apiKey');
String APIkey = '8db7bfc9e3d846ccab477c4862e4235920240705140121945052';
String OrgID = '116774db5a58484196a7561a92e47700';

class ProductController {
  static Future<dynamic> getProducts() async {
    List<ProductModel> allProducts = [];
    try {
      http.Response response = await http.get(
        Uri.parse(timbuUrl),
      );
      print(jsonDecode(response.body)['items'][0]);
      if (response.statusCode == 200) {
        final items = jsonDecode(response.body)['items'];
        for (int i = 0; i < items.length; i++) {
          allProducts.add(
            ProductModel.fromMap(items[i]),
          );
        }

        return allProducts;
      }

      return [];
    } on http.ClientException catch (e) {
      print(e);
      return Error();
    } catch (e) {
      print(e);
      return Error();
    }
  }
}
