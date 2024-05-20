import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../provider/user_provider.dart';
import '../../../../utils/constant.dart';
import '../../../condition_status_views/status_successful_screen/views/status_succesful_screen.dart';

class AddUserListScreen extends StatefulWidget {
  const AddUserListScreen({Key? key}) : super(key: key);

  @override
  State<AddUserListScreen> createState() => _AddUserListScreenState();
}

class _AddUserListScreenState extends State<AddUserListScreen> {
  var thisJob = ['Front End', 'Back End', 'Data Analyst'];
  String? selectedJob;
  late String name;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
        leading: Row(
          children: [
            SizedBox(
              width: 8.w,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100).r,
                  color: Color(Constant.greyECF0F4),
                ),
                child: Icon(Icons.close),
              ),
            ),
          ],
        ),
        backgroundColor: Color(Constant.whiteFFFFFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0).r,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 18.h,
              ),
              Text(
                'Name'.toUpperCase(),
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                cursorColor: Color(Constant.orangeFF7622),
                decoration: InputDecoration(
                  hintText: 'This Name'.toUpperCase(),
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Color(Constant.black32343E),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14).r,
                  ),
                  filled: true,
                  fillColor: Color(Constant.greyF0F5FA),
                ),
              ),
              SizedBox(
                height: 18.h,
              ),
              Text(
                'Job'.toUpperCase(),
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFormField(
                controller: TextEditingController(text: selectedJob),
                validator: (value) {
                  if (selectedJob == null || selectedJob!.isEmpty) {
                    return 'Please select a job';
                  }
                  return null;
                },
                onTap: () {
                  showModalBottomSheet(
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 210.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5.r,
                              color: Color(Constant.black32343E),
                            ),
                          ],
                          color: Color(Constant.whiteFFFFFF),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20).r,
                            topLeft: Radius.circular(20).r,
                          ).r,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0).r,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10.h),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: thisJob.length,
                                itemBuilder: (context, index) {
                                  final job = thisJob[index];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedJob = job;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                job,
                                                style:
                                                    TextStyle(fontSize: 18.sp),
                                              ),
                                              Icon(Icons
                                                  .arrow_forward_ios_rounded),
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                showCursor: false,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'This Job'.toUpperCase(),
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Color(Constant.black32343E),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14).r,
                  ),
                  filled: true,
                  fillColor: Color(Constant.greyF0F5FA),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20).r,
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                      backgroundColor: Color(Constant.orangeFF7622),
                    ),
                    onPressed: () {
                      // Validate form
                      if (_formKey.currentState!.validate()) {
                        // Panggil createUser dari provider
                        Provider.of<UserProvider>(context, listen: false)
                            .createUser(name, selectedJob!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StatusSuccesfulScreen(isCreate: true),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Create'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(Constant.whiteFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
