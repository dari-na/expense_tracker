import 'package:expense_tracker/skeleton_pages/skeleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SkAuthPage extends StatelessWidget {
  const SkAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Auth'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Sign in anonymously for testing
              UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
              print('Signed in with temporary account: ${userCredential.user?.uid}');

              // Navigate to the HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Skeleton()),
              );
            } catch (e) {
              print('Failed to sign in: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          child: const Text('Sign in Anonymously'),
        ),
      ),
    );
  }
}
