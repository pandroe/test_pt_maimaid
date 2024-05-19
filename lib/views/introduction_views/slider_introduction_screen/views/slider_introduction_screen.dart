import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_pt_maimaid/views/user_list_views/user_list_screen/views/user_list_screen.dart';

import '../../../../utils/constant.dart';

class ImageSliderWithDots extends StatefulWidget {
  const ImageSliderWithDots({super.key});

  @override
  State<ImageSliderWithDots> createState() => _ImageSliderWithDotsState();
}

class _ImageSliderWithDotsState extends State<ImageSliderWithDots> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> sliderData = [
    {
      "image": "assets/images/logo.png",
      "title": "Selamat Datang di Maimaid Indonesia",
      "description":
          "Perkenalan singkat mengenai perusahaan, visi, misi, dan nilai-nilai inti perusahaan."
    },
    {
      "image": "assets/images/slider_intro/slider_1.png",
      "title": "Posisi yang Tersedia",
      "description":
          "Daftar posisi yang sedang dibuka beserta deskripsi singkat tugas dan tanggung jawab utama."
    },
    {
      "image": "assets/images/slider_intro/slider_2.png",
      "title": "Budaya dan Lingkungan Kerja",
      "description":
          "Informasi tentang budaya perusahaan, suasana kerja, dan fasilitas yang disediakan untuk karyawan."
    },
    {
      "image": "assets/images/slider_intro/slider_3.png",
      "title": "Cara Melamar",
      "description":
          "Langkah-langkah cara melamar pekerjaan di perusahaan tersebut, proses seleksi, dan kontak untuk informasi lebih lanjut."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: sliderData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = sliderData[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16.w / 9.h,
                        child: Image.asset(
                          item["image"]!,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        item["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(Constant.black32343E),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16).r,
                        child: Text(
                          item["description"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(Constant.grey646982)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: sliderData.map((url) {
                int index = sliderData.indexOf(url);
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _currentIndex == index ? 12.w : 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2).r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Color(Constant.orangeFF7622)
                        : Color(Constant.orangeFFE1CE),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _currentIndex < 3
                ? Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(450.w, 50.h),
                            backgroundColor: Color(Constant.orangeFF7622)),
                        onPressed: _currentIndex < sliderData.length - 1
                            ? () {
                                _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              }
                            : null,
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Color(Constant.whiteFFFFFF)),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _currentIndex < sliderData.length - 1
                          ? InkWell(
                              onTap: () {
                                _pageController
                                    .jumpToPage(sliderData.length + 3);
                              },
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(Constant.grey646982)),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(450.w, 50.h),
                        backgroundColor: Color(Constant.orangeFF7622)),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserListScreen(),
                          ),
                          (route) => false);
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          fontSize: 14.sp, color: Color(Constant.whiteFFFFFF)),
                    ),
                  ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
