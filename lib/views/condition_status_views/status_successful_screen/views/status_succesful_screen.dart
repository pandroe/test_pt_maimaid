import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/constant.dart';

class StatusSuccesfulScreen extends StatefulWidget {
  const StatusSuccesfulScreen({super.key});

  @override
  State<StatusSuccesfulScreen> createState() => _StatusSuccesfulScreenState();
}

class _StatusSuccesfulScreenState extends State<StatusSuccesfulScreen> {
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
                height: 100.h),
            SizedBox(
              height: 12.h,
            ),
            Text(
              'Delete Successful',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(
              height: 18.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20).r),
                  minimumSize: Size(double.infinity, 55.h),
                  backgroundColor: Color(Constant.orangeFF7622)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Ok".toUpperCase(),
                style: TextStyle(
                    fontSize: 14.sp, color: Color(Constant.whiteFFFFFF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
