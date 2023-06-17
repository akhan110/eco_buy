import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/models/productsModel.dart';
import 'package:eco_buy/widgets/eco_button.dart';
import 'package:eco_buy/widgets/ecotextfeild.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

class AddProductsScreen extends StatefulWidget {
  static const String id = 'add';

  AddProductsScreen({super.key});

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  TextEditingController categoryC = TextEditingController();
  TextEditingController idC = TextEditingController();
  TextEditingController productNameC = TextEditingController();
  TextEditingController detailC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController discountPriceC = TextEditingController();
  TextEditingController serialCodeC = TextEditingController();
  TextEditingController brandC = TextEditingController();
  bool isOnSale = false;
  bool isPopular = false;
  bool isFavorite = false;
  var uuid = const Uuid();

  String? selectedValue;
  final imagePicker = ImagePicker();
  List<XFile> imageList = [];
  List<String> imageUrls = [];
  bool isSaving = false;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    List categories = [
      "GROCERY",
      "PHARMACY",
      "COSMETICS",
      "ELECTRONICS",
      'GARMENTS',
    ];

    return SingleChildScrollView(
      child: Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Column(
              children: [
                const Text(
                  'ADD PRODUCTS SCREEN',
                  style: TextStyle(fontSize: 25),
                ),
                EcoButton(
                  title: "PICK IMAGES",
                  onPress: () {
                    pickImage();
                  },
                  isLoginButton: true,
                ),
                // EcoButton(
                //   title: "UPLOAD IMAGES",
                //   onPress: () {
                //     uploadImages();
                //   },
                //   isLoading: isUploading,
                //   isLoginButton: true,
                // ),
                Container(
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                        ),
                        itemCount: imageList.length,
                        itemBuilder: (BuildContext context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image.network(
                                  File(imageList[index].path).path,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      imageList.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.cancel))
                            ],
                          );
                        })),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        hint: const Text('Select category'),
                        iconEnabledColor: Colors.grey,
                        iconDisabledColor: Colors.grey,
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(10),
                        value: selectedValue,
                        items: categories
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(
                                  e,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                            print(selectedValue);
                          });
                        }),
                  ),
                ),
                const SizedBox(height: 10),
                EcoField(
                  isFilledColor: true,
                  controller: productNameC,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                  },
                  hintText: 'Enter product name',
                ),
                const SizedBox(height: 10),
                EcoField(
                  isFilledColor: true,
                  minLines: 5,
                  controller: detailC,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                  },
                  hintText: 'Enter product detail',
                ),
                const SizedBox(height: 10),
                EcoField(
                  isFilledColor: true,
                  controller: priceC,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                  },
                  hintText: 'Enter product price',
                ),
                const SizedBox(height: 10),
                EcoField(
                  isFilledColor: true,
                  controller: discountPriceC,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                  },
                  hintText: 'Enter product discounted price',
                ),
                const SizedBox(height: 10),
                EcoField(
                  isFilledColor: true,
                  controller: brandC,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                  },
                  hintText: 'Enter brand name',
                ),
                EcoButton(
                  isLoading: isSaving,
                  onPress: () {
                    save();
                  },
                  title: 'SAVE',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  save() async {
    setState(() {
      isSaving = true;
    });
    await uploadImages();
    await Products.addProducts(
      Products(
        category: selectedValue,
        id: uuid.v4(),
        brand: brandC.text,
        productName: productNameC.text,
        detail: detailC.text,
        price: int.parse(priceC.text),
        discountPrice: int.parse(discountPriceC.text),
        serialCode: serialCodeC.text,
        imageUrls: imageUrls,
        isSale: isOnSale,
        isPopular: isPopular,
        isFavourite: isFavorite,
      ),
    ).whenComplete(() {
      setState(() {
        isSaving = false;
        imageUrls.clear();
        imageList.clear();
        clearFields();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("ADDED SUCCESSFULLY")));
      });
    });
    // await FirebaseFirestore.instance
    //     .collection("products")
    //     .add({"images": imageUrls}).whenComplete(() {
    //   setState(() {
    //     isSaving = false;
    //     images.clear();
    //     imageUrls.clear();
    //   });
    // });
  }

  clearFields() {
    setState(() {
      // selectedValue = "";
      // productNameC.clear();
      // detailC.clear();
    });
  }

  pickImage() async {
    final List<XFile> pickImage = await imagePicker.pickMultiImage();
    if (pickImage != null) {
      setState(() {
        imageList.addAll(pickImage);
      });
    } else {
      print('No Images Selected');
    }
  }

  Future postImages(XFile? imageFile) async {
    setState(() {
      isUploading = true;
    });
    String urls;
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imageFile!.name);
    if (kIsWeb) {
      await ref.putData(await imageFile.readAsBytes());
      SettableMetadata(contentType: "image/jpeg");
      urls = await ref.getDownloadURL();
      setState(() {
        isUploading = false;
      });
      return urls;
    }
  }

  uploadImages() async {
    for (var image in imageList) {
      await postImages(image).then((downloadUrl) => imageUrls.add(downloadUrl));
    }
  }
}
