import 'package:peanote/constant/base_string.dart';
import 'package:peanote/data/baseapi.dart';

class HomeController {
  Future<dynamic> fetchTodos() async {
    var data = await BaseApi().get(BaseString.todos);
    return data;
  }
}
