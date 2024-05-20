import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:test_pt_maimaid/views/user_list_views/add_user_list_screen/views/add_user_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../provider/user_provider.dart';
import '../../../../utils/constant.dart';
import '../../../condition_status_views/status_successful_screen/views/status_succesful_screen.dart';
import '../../update_user_list_screen/views/update_user_list_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  String? dropdownvalue;
  bool _isPopupMenuVisible = false;
  // List of items in our dropdown menu
  var itemsNotSelected = [
    'Select',
    'Update',
    'Delete',
  ];

  var itemsSelected = [
    'Deselect',
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddUserListScreen(),
                    ));
              },
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100).r,
                  color: Color(Constant.greyECF0F4),
                ),
                child: Icon(Icons.add),
              ),
            ),
            SizedBox(
              width: 15.w,
            )
          ],
        ),
        body: TabBarView(
          children: [
            // Content for "Not Selected" tab
            Padding(
              padding: const EdgeInsets.all(18.0).r,
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return RefreshIndicator(
                    color: Color(Constant.orangeFF7622),
                    onRefresh: () async {
                      await context.read<UserProvider>().fetchUsers();
                    },
                    child: ListView.builder(
                      itemCount: userProvider.users.length +
                          (userProvider.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == userProvider.users.length) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color(Constant.orangeFF7622),
                            ),
                          );
                        }
                        final user = userProvider.users[index];
                        return GestureDetector(
                          onTap: () {
                            context.read<UserProvider>().selectUser(user);
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(user.avatar),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(20).r,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          color: Color(Constant.orangeFF7622),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  PopupMenuButton(
                                    onSelected: (String itemNotSelected) {
                                      if (itemNotSelected == 'Delete') {
                                        setState(() {
                                          _isPopupMenuVisible = false;
                                        });
                                        showModalBottomSheet(
                                          barrierColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: 170.h,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 5.r,
                                                    color: Color(
                                                        Constant.black32343E),
                                                  ),
                                                ],
                                                color:
                                                    Color(Constant.whiteFFFFFF),
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(20).r,
                                                  topLeft:
                                                      Radius.circular(20).r,
                                                ).r,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0)
                                                        .r,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Are You Sure?',
                                                      style: TextStyle(
                                                          fontSize: 18.sp),
                                                    ),
                                                    SizedBox(height: 21.h),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                      .circular(
                                                                          20)
                                                                  .r,
                                                        ),
                                                        minimumSize: Size(
                                                            double.infinity,
                                                            50.h),
                                                        backgroundColor: Color(
                                                            Constant
                                                                .orangeFF7622),
                                                      ),
                                                      onPressed: () {
                                                        int userId = user.id;
                                                        context
                                                            .read<
                                                                UserProvider>()
                                                            .deleteUser(userId);
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                StatusSuccesfulScreen(
                                                              isCreate: false,
                                                              isUpdate: false,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        "Delete Now"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: Color(Constant
                                                              .whiteFFFFFF),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      } else if (itemNotSelected == 'Update') {
                                        setState(() {
                                          _isPopupMenuVisible = false;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateUserListScreen(
                                              user: user,
                                            ),
                                          ),
                                        );
                                      } else if (itemNotSelected == 'Select') {
                                        context
                                            .read<UserProvider>()
                                            .selectUser(user);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return itemsNotSelected
                                          .map((String itemNotSelected) {
                                        return PopupMenuItem(
                                          value: itemNotSelected,
                                          child: Text(
                                            itemNotSelected,
                                            style: TextStyle(
                                              color: itemNotSelected == 'Delete'
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
                              SizedBox(height: 25.h),
                            ],
                          ),
                        );
                      },
                      controller: _scrollController,
                    ),
                  );
                },
              ),
            ),
            // Content for "Selected" tab
            Padding(
              padding: const EdgeInsets.all(18.0).r,
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return ListView.builder(
                    itemCount: userProvider.selectedUsers.length,
                    itemBuilder: (context, index) {
                      final user = userProvider.selectedUsers[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle user tap if needed
                        },
                        child: Column(
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
                                    borderRadius: BorderRadius.circular(20).r,
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
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      user.email,
                                      style: TextStyle(
                                        color: Color(Constant.orangeFF7622),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                PopupMenuButton(
                                  onSelected: (String itemSelected) {
                                    if (itemSelected == 'Delete') {
                                      setState(() {
                                        _isPopupMenuVisible = false;
                                      });
                                      showModalBottomSheet(
                                        barrierColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            height: 170.h,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 5.r,
                                                  color: Color(
                                                      Constant.black32343E),
                                                ),
                                              ],
                                              color:
                                                  Color(Constant.whiteFFFFFF),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20).r,
                                                topLeft: Radius.circular(20).r,
                                              ).r,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0).r,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Are You Sure?',
                                                    style: TextStyle(
                                                        fontSize: 18.sp),
                                                  ),
                                                  SizedBox(height: 21.h),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                    .circular(
                                                                        20)
                                                                .r,
                                                      ),
                                                      minimumSize: Size(
                                                          double.infinity,
                                                          50.h),
                                                      backgroundColor: Color(
                                                          Constant
                                                              .orangeFF7622),
                                                    ),
                                                    onPressed: () {
                                                      int userId = user.id;
                                                      context
                                                          .read<UserProvider>()
                                                          .deleteUser(userId);
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StatusSuccesfulScreen(
                                                            isCreate: false,
                                                            isUpdate: false,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      "Delete Now"
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Color(Constant
                                                            .whiteFFFFFF),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else if (itemSelected == 'Update') {
                                      setState(() {
                                        _isPopupMenuVisible = false;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateUserListScreen(
                                            user: user,
                                          ),
                                        ),
                                      );
                                    } else if (itemSelected == 'Deselect') {
                                      context
                                          .read<UserProvider>()
                                          .deselectUser(user);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return itemsSelected
                                        .map((String itemSelected) {
                                      return PopupMenuItem(
                                        value: itemSelected,
                                        child: Text(
                                          itemSelected,
                                          style: TextStyle(
                                            color: itemSelected == 'Delete'
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
                            SizedBox(height: 25.h),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
