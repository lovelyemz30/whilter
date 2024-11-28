import 'package:clothes/users/userPreferences/current_user.dart';
import 'package:clothes/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import '../authentication/login_screen.dart';

class ProfileFragmentScreen extends StatelessWidget {
  final int userId;
  final String userEmail;
  final String userName;

  ProfileFragmentScreen({
    Key? key,
    required this.userId,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  signOutUser(BuildContext context) async {
    var resultResponse = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: const Text(
            "Logout",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop("loggedOut");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (resultResponse == "loggedOut") {
      // Remove the user sharedPreference
      // Delete user from phone storage
      RememberUserPrefs.removeUserInfo().then((value) {
        // Navigate to the home route ("/") and remove all previous routes
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      });
    }
  }

  Widget userInfoItemProfile(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            userData,
            style: const TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Center(
          child: Image.asset(
            "images/woman.png",
            width: 240,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        userInfoItemProfile(Icons.person, "User Name: $userName"),
        const SizedBox(
          height: 20,
        ),
        userInfoItemProfile(Icons.email, "Email: $userEmail"),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Material(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  signOutUser(context);
                },
                borderRadius: BorderRadius.circular(32),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
