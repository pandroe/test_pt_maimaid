// Di StatusSuccesfulScreen

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:test_pt_maimaid/views/user_list_views/user_list_screen/views/user_list_screen.dart';
import '../../../../utils/constant.dart';

class StatusSuccesfulScreen extends StatelessWidget {
  final bool isCreate;

  const StatusSuccesfulScreen({required this.isCreate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/icons/lottie/status/check_status_successful.json',
              frameRate: FrameRate.max,
              height: 100.h,
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              isCreate ? 'Create Successful' : 'Delete Successful',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(
              height: 18.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20).r,
                ),
                minimumSize: Size(double.infinity, 55.h),
                backgroundColor: Color(Constant.orangeFF7622),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                "Ok".toUpperCase(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(Constant.whiteFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
