import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//image picker for picking the image
//firebase storage for uploading the image
//cloud restore for saving the url for uploaded image to our application

class ImageUpload extends StatefulWidget {
  String? userid;

  ImageUpload({Key? key,this.userid}) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final imagepicker=ImagePicker();
  String? downloadURL;
  //image picker

  Future ImagePickerMethod() async{
    //picking the file
    final pick= await imagepicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pick!=null){
        _image=File(pick.path);
      }
      else
        {
          //showing a snap bar
          showSnackBar("No files Selected",Duration(milliseconds:400));

        }
    });

  }
  //uploading the image geting the downloaded url and then
  //adding that download url to our cloudefirestore

  Future uploadImage() async{
    final postID=DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
    Reference ref= FirebaseStorage.instance.ref().child("${widget.userid}/images").
    child("post_$postID");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    //uploading to cloudfirestore

    await firebaseFirestore.collection("users")
        .doc(widget.userid)
        .collection("images")
        .add({'downloadURL':downloadURL})
        .whenComplete(() => showSnackBar("image Upload successfully",
            Duration(seconds: 2)));;

  }

  //snapbar for showing errors
showSnackBar(String snackText,Duration d){
final snackBar=SnackBar(content: Text(snackText),duration: d,);
ScaffoldMessenger.of(context).showSnackBar(snackBar);

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Upload"),
      ),
      body: Center(
        child: Padding(
          padding:EdgeInsets.all(8),
          //for rounded rectangular border
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 550,
              width: double.infinity,
              child: Column(
                children: [
                  const Text("Upload Image"),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(flex:4,child: Container(
                    width: 320,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red),),
                      child:Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child:_image==null?
                                    const Center(child:Text("No Image Is selected"))
                                :Image.file(_image!),
                            ),
                            ElevatedButton(onPressed: (){
                              ImagePickerMethod();
                            }, child: Text("select image")),
                            ElevatedButton(onPressed: (){
                              //upload only when the image has value
                              if(_image!=null) {
                                uploadImage();
                              }
                              else{
                                showSnackBar("Select image first",
                                    Duration(milliseconds: 400));
                              }
                            }, child: Text("Upload image")),

                          ],
                        ),
                      )
                  ),

                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
