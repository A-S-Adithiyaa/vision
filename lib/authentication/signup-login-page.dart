import 'package:flutter/material.dart';
import 'package:vision/authentication/login-screen.dart';
import 'package:vision/authentication/signup-screen.dart';
import 'package:vision/custom-variables.dart';

class SignupLoginPage extends StatelessWidget {
  const SignupLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/splashScreenLogo.png', // Replace with your logo image asset
                height: 180,
                width: 180,
              ),

              SizedBox(height: 16),

              // Company Name
              Text('VISION',
                  style: getNunito(fontSize: 30, fontWeight: FontWeight.w700)),

              SizedBox(height: 8),

              // Tagline
              Text('Know-How your ORIGAMI', style: getNunito()),

              SizedBox(height: 32),

              // Signup Button
              ElevatedButton(
                onPressed: () {
                  // Handle signup button press
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SignUpScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(-1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutQuart;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                child: Text(
                  'Signup',
                  style: getNunito(),
                ),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(150, 40), backgroundColor: MyColors.comet),
              ),

              SizedBox(height: 16),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Handle login button press
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          LoginScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutQuart;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 800),
                    ),
                  );
                },
                child: Text(
                  'Login',
                  style: getNunito(),
                ),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(150, 40),
                    backgroundColor: MyColors.primaryBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
