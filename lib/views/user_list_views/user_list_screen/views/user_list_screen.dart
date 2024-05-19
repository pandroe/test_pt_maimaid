import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../provider/user_provider.dart';
import '../../../../utils/constant.dart'; // Import library for screen size scaling

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  String? dropdownvalue;
  bool _isPopupMenuVisible = false;
  // List of items in our dropdown menu
  var items = [
    'Select',
    'Update',
    'Delete',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(Constant.whiteFFFFFF),
          title: Text('User List'),
          bottom: TabBar(
            indicatorColor: Color(Constant.orangeFF7622),
            labelColor: Color(Constant.orangeFB6D3A),
            labelStyle: TextStyle(fontSize: 14.sp),
            tabs: [
              Tab(
                text: 'Not Selected',
              ),
              Tab(text: 'Selected'),
            ],
          ),
          actions: [
            GestureDetector(
                onTap: () {},
                child: Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100).r,
                      color: Color(Constant.greyECF0F4)),
                  child: Icon(Icons.add),
                )),
            SizedBox(
              width: 15.w,
            )
          ],
        ),
        body: TabBarView(
          children: [
            // Content for "Not Selected" tab
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return ListView.builder(
                    itemCount: userProvider.users.length + 1,
                    itemBuilder: (context, index) {
                      if (index == userProvider.users.length) {
                        if (userProvider.isLoading) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Color(Constant.orangeFF7622),
                          ));
                        } else {
                          return Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(450.w, 50.h),
                                    backgroundColor:
                                        Color(Constant.orangeFF7622)),
                                onPressed: () => userProvider.fetchUsers(),
                                child: Text(
                                  'Load More',
                                  style: TextStyle(
                                      color: Color(Constant.whiteFFFFFF)),
                                ),
                              ),
                              SizedBox(
                                height: 25.h,
                              )
                            ],
                          );
                        }
                      }
                      final user = userProvider.users[index];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(user.avatar),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                        color: Color(Constant.orangeFF7622),
                                        fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              PopupMenuButton(
                                onSelected: (String item) {
                                  if (item == 'Delete') {
                                    int userId = user.id;
                                    context
                                        .read<UserProvider>()
                                        .deleteUser(userId);
                                    // Set popup menu visibility to false after press button
                                    setState(() {
                                      _isPopupMenuVisible = false;
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return items.map((String item) {
                                    return PopupMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: item == 'Delete'
                                              ? Color(Constant.redFF0606)
                                              : Color(Constant.black32343E),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25.h,
                          )
                        ],
                      );
                    },
                    controller: _scrollController,
                  );
                },
              ),
            ),
            // Placeholder content for "Selected" tab
            Center(
              child: Text('Selected Users'),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final userProvider = context.read<UserProvider>();

    if (currentScroll >= maxScroll) {
      if (!userProvider.isLoading) {
        userProvider.fetchUsers();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
