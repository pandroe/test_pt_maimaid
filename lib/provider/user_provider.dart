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

  // Create User
  Future<void> createUser(String name, String job) async {
    try {
      // Panggil method createUser dari service
      await _apiService.createUser(name, job);
      // Panggil notifyListeners untuk memberi tahu listener bahwa state telah berubah
      notifyListeners();
    } catch (error) {
      // Tangani kesalahan jika terjadi
      print('Error creating user: $error');
      // Atau Anda bisa melempar kembali kesalahan ini
      throw error;
    }
  }

  // Update User
  Future<void> updateUser(int userId, String name, String job) async {
    try {
      await _apiService.updateUser(userId, name, job);
      _users = _users.map((user) {
        if (user.id == userId) {
          return UserModel(
            id: user.id,
            email: user.email,
            firstName: name.split(' ')[0],
            lastName: name.split(' ').length > 1 ? name.split(' ')[1] : '',
            avatar: user.avatar,
          );
        }
        return user;
      }).toList();
      notifyListeners();
    } catch (error) {
      print('Error updating user: $error');
      throw error;
    }
  }
}
