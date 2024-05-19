import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../services/user_services.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  int _page = 1;
  int _perPage = 10;
  bool _isLoading = false;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;

  final UserService _apiService = UserService();

  // Fetch users
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<UserModel> fetchedUsers =
          await _apiService.getUsers(page: _page, perPage: _perPage);
      _users.addAll(fetchedUsers);
      _page++;
    } catch (e) {
      print('Error fetching users: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // Delete user
  Future<void> deleteUser(int userId) async {
    try {
      await _apiService.deleteUser(userId);
      // Remove the user from the local list
      _users.removeWhere((user) => user.id == userId);
      notifyListeners();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
