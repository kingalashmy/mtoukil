// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:suivi_stage2/compenants/MyButton.dart';
import 'package:suivi_stage2/compenants/MyTextField.dart';
// import 'package:suivi_stage2/pages/Profile.dart';
import 'package:suivi_stage2/pages/home.dart';
import 'package:suivi_stage2/sqldb.dart';



class LoginPage extends StatefulWidget {

  // ignore: prefer_const_constructors_in_immutables
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bool isVisible = false;
  bool loginError = false;

  
  

  // creating an instance of our class SqlDb after importing it
  SqlDb sqldb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // empty space here

              // SizedBox(
              //   height: 40,
              // ),
              // // logo (Icon)

              // Icon(Icons.school, size: 100, color: Colors.white,),
              Image.asset('lib/images/ImageLoginPage.png' , height: 200, width:300),

              SizedBox(
                height: 25,
              ),

              // welcome text
              Text(
                "Connectez-vous !",
                style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 25,
              ),
              // username textfield
              MyTextField(
                prefixIcon: Icons.email,
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              SizedBox(
                height: 15,
              ),
              // password textField

              MyTextField(
                prefixIcon: Icons.lock,
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
        
              ),
              SizedBox(
                height: 10,
              ),

              // forgot password

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Mot de passe oublié?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 25,
              ),

              // signin button

              MyButton(
              TextButton: "Login",
              ButtonColor: Colors.blue[400],
              onPressed: () async {
                Map<String, dynamic>? userData = await sqldb.loginUser(
                    emailController.text, passwordController.text);
                if (userData != null) {
                  // Redirigez vers la page ProfilePage et passez les informations de l'utilisateur
                  Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(userData: userData),
                  ),
                  );
                } else {
                  setState(() {
                    loginError = true;
                  });
                }
              },
            ),

              SizedBox(height: 20 ,),

              if (loginError == true)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    'E-mail ou mot de passe incorrect!',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            
             
              MyButton(
                TextButton: "Create User",
                ButtonColor: Colors.orange,
                onPressed: () async{
                  // print("OK!");
                 int response = await sqldb.insertData("INSERT INTO 'Utilisateurs' (nom_utilisateur, prenom_utilisateur, email, Role, password) VALUES ('yousra', 'Al-maimouny', 'yousra@gmail.com', 'Etudiant', '123')");
         
                 print(response); 
                },
              ),

              SizedBox(height: 10 ,),

               MyButton(
                TextButton: "Show User",
                ButtonColor: Colors.blue,
                onPressed: () async{
                 List<Map> response = await sqldb.readData("SELECT * FROM 'Utilisateurs' ");

                 print("$response"); 
                },
              ),

              SizedBox(height: 10 ,),
              //  MyButton(
              //   TextButton: "Delete User",
              //   ButtonColor: Colors.orange,
              //   onPressed: () async{
              //     // print("OK!");
              //    int response = await sqldb.deleteData("DELETE FROM 'Utilisateurs' WHERE id = 4");
              //    print(response); 
              //   },
              // ),

             

              // devider here to continue with

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 25),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Divider(
              //           thickness: 0.5,
              //           color: Colors.grey[400],
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         child: Text("Or continue with",
              //             style: TextStyle(color: Colors.grey[700])),
              //       ),
              //       Expanded(
              //         child: Divider(
              //           thickness: 0.5,
              //           color: Colors.grey[400],
              //         ),
              //       ),
              //     ],
              //   ),


              // ),

              // SizedBox(height: 30),

              // // differenet sign in buttons 

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Square(pathImage: 'lib/images/googleLogo.png'),
              //     SizedBox(width: 25),
              //     Square(pathImage: 'lib/images/logoFb.png'),
              //   ],
              // )


            ],
          ),
        ),
      ),
    );
  }
}