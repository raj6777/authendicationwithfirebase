import 'package:authendication_firebase/model/user_model.dart';
import 'package:authendication_firebase/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;

  //Our Form Key
  final _formKey = GlobalKey<FormState>();
  @override
  //Editing Controller

  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  Widget build(BuildContext context) {
    //This is FirstName Field
    final firstField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("first name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter a valid name (Min 3 charcter)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //This is SecondName Field
    final secondField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("second name cannot be Empty");
        }
      },
      onSaved: (value) {
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Second Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //This is Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      //validator:(){},
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter your Email");
        }
        //reg expression for email validation

        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a Valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //This is Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      //validator:(){},
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter a valid password (Min 6 charcter)");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },

      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //This is ConfirmPassword Field
    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      //keyboardType: TextInputType.emailAddress,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text!=
            passwordEditingController.text) {
          return "password dont match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },

      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //This is SignUp Button
    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);

        },
        child: Text(
          'SignUp',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
          onPressed: () {
            //Passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        'asset/images/1.jpg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    firstField,
                    SizedBox(
                      height: 20,
                    ),
                    secondField,
                    SizedBox(
                      height: 20,
                    ),
                    emailField,
                    SizedBox(
                      height: 20,
                    ),
                    passwordField,
                    SizedBox(
                      height: 20,
                    ),
                    confirmpasswordField,
                    SizedBox(
                      height: 20,
                    ),
                    signUpButton,
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    //calling our firebase
    //calling our user model
    //sending these values
    FirebaseFirestore  firebaseFirestore= FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel=UserModel();

    //writing alll the values
    userModel.email = user!.email;
    userModel.uid=user.uid;
    userModel.firstName=firstNameEditingController.text;
    userModel.secondName=secondNameEditingController.text;


    await firebaseFirestore
    .collection("users")
    .doc(user.uid)
    .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");
    
    Navigator.pushAndRemoveUntil((context),MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
    
  }
}
