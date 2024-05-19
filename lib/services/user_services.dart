import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';
import '../utils/api.dart';

class UserService {
  // Get User
  Future<List<UserModel>> getUsers(
      {required int page, required int perPage}) async {
    String apiUrl = '$apiUser?per_page=$perPage&page=$page';
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> usersData = jsonData['data'];
      List<UserModel> users = [];
      for (var userData in usersData) {
        users.add(UserModel.fromJson(userData));
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Delete User
  Future<void> deleteUser(int userId) async {
    try {
      // Send delete request to server
      await http.delete(Uri.parse('$apiUser/$userId'));
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}
