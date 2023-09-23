import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:chat_gpt/screens/home_pages/home_screen.dart';
import 'package:chat_gpt/utils/extension.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_gpt/screens/hisrory_image_pages/history_image_screen_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class ImageHistoeyView extends StatefulWidget {
  String image;
  String Uid;
  String iid;
  // Uint8List data1;
  ImageHistoeyView({
    super.key,
    required this.image,
    required this.Uid,
    required this.iid,
  });

  @override
  State<ImageHistoeyView> createState() => _ImageHistoeyViewState();
}

class _ImageHistoeyViewState extends State<ImageHistoeyView> {
  HistoryImageController historyImageController =
      Get.put(HistoryImageController());
   Uint8List? data1;
  Future readNetworkImage() async {
    // final ByteData data =
    //     await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
    // final Uint8List bytes = data.buffer.asUint8List();
    // data1 = bytes;

    try {
      var response = await Dio().get(widget.image,
          options: Options(responseType: ResponseType.bytes));
      data1 = Uint8List.fromList(response.data);
      print(data1);
    } catch (e) {
      print('----------> Image  Store Error -> $e');
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readNetworkImage();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: Stack(children: [
        Center(
            child: CachedNetworkImage(
          imageUrl:
              "https://unextenuated-flower.000webhostapp.com/chatGpt/uploads/${widget.image}",
          placeholder: (context, url) => Center(
              child: Container(
                  height: 20,
                  width: 20,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.textTheme.headline1!.color))),
        )),
        
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded,
                      color: context.textTheme.headline1!.color, size: 18),
                  5.0.addWSpace(),
                  Text(
                    'imagePreview'.tr,
                    style: TextStyle(
                        color: context.textTheme.headline1!.color,
                        fontSize: 18),
                  )
                ],
              ).marginOnly(top: 50, left: 20),
            ),
            Row(
              children: [
                button(
                    text: "Crop".tr,
                    onTap: () async {
                      var response = await Dio().get(
                          "https://unextenuated-flower.000webhostapp.com/chatGpt/uploads/${widget.image}",
                          options: Options(responseType: ResponseType.bytes));
                      Uint8List data = Uint8List.fromList(response.data);
                      print(data);
                      // ignore: use_build_context_synchronously
                      final editedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageCropper(image: data),
                        ),
                      );
                       Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false);
                      print(editedImage);
                      await historyImageController.Updateall(k: {
                          "U_Id": widget.Uid,
                          "I_Id": widget.iid,
                          "Image": editedImage,
                          "ImageName": "om"
                        });
                      if (editedImage != null) {
                        
                        data1 = editedImage;
                        setState(() {
                          
                        });
                       
                      }
                    }),
                button(
                    text: "Filters".tr,
                    onTap: () async {
                      var response = await Dio().get(
                          "https://unextenuated-flower.000webhostapp.com/chatGpt/uploads/${widget.image}",
                          options: Options(responseType: ResponseType.bytes));
                      Uint8List data = Uint8List.fromList(response.data);
                      print(data);
                      // ignore: use_build_context_synchronously

                      final editedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageFilters(image: data),
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (route) => false);
                      print(editedImage);
                      await historyImageController.Updateall(k: {
                          "U_Id": widget.Uid,
                          "I_Id": widget.iid,
                          "Image": editedImage,
                          "ImageName": "om"
                        });
                      if (editedImage != null) {
                        
                        data1 = editedImage;
                        setState(() {
                          
                        });
                        
                      }
                    }),
                button(
                    text: "save".tr,
                    onTap: () async {
                      try {
                        var response = await Dio().get(widget.image,
                            options: Options(responseType: ResponseType.bytes));
                        await ImageGallerySaver.saveImage(
                            Uint8List.fromList(response.data));
                      } catch (e) {
                        print('----------> Image  Store Error -> $e');
                      }
                    }),
              ],
            ).marginSymmetric(horizontal: 20, vertical: 15)
          ],
        )
      ]),
    );
  }

  Widget button({required String text, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: const Color(0xff56CBFF),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Text(
            text,
            style: TextStyle(
                fontSize: 17, color: Colors.white, fontWeight: FontWeight.w800),
          )),
        ).marginAll(3),
      ),
    );
  }
}
