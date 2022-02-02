import 'package:authendication_firebase/imageupload/image_upload.dart';
import 'package:authendication_firebase/imageupload/show_images.dart';
import 'package:authendication_firebase/model/user_model.dart';
import 'package:authendication_firebase/screens/login_screen.dart';
import 'package:authendication_firebase/screens/pushnotification1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user=FirebaseAuth.instance.currentUser;
  UserModel loggedinUser=UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get()
    .then((value){
      this.loggedinUser=UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: _appbar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset(
                  'asset/images/1.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                'Welcome Back',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${loggedinUser.firstName} ${loggedinUser.secondName}',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${loggedinUser.email}',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${loggedinUser.uid}',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageUpload
                  (userid: loggedinUser.uid,)));
              }, child: Text("Upload Images")),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowUploads(userId: loggedinUser.uid,)));
              }, child: Text("Show Images")),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PushNotification1()));
              }, child:Text("Push Notification")),

            ],
          ),
        ),
      ),
    );
  }
  Future<void> logout(BuildContext context) async
  {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement
      (MaterialPageRoute(builder: (context)=>LoginScreen()));
  }
  _appbar(){
    //getting the size of our app bar
    //we will get the height

    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
     child:AppBar(title: const Text("profile"),
      actions: [
        IconButton(onPressed: (){
          logout(context);
        }, icon: Icon(Icons.logout),)
    ],
    ),

     preferredSize:Size.fromHeight(appBarHeight));
  }
}
