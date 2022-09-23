import 'package:client_shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "profileUpdateScreen");
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Text(
                    "A",
                    style: TextStyle(
                      color: Color(0xff3B7B3F),
                    ),
                  ),
                  backgroundColor: Color(0xff29BF79).withOpacity(0.2),
                ),
                Text(
                  "Awadhut Shah",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "google_fonts/DaysOne-Regular.ttf",
                  ),
                ).pOnly(left: 16),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ],
            ),
          ),
          ListTile(
            iconColor: CustomTheme.primaryColors.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Image.asset(
              "images/notifications.png",
            ),
            minLeadingWidth: 20.0,
            title: const Text(
              "Notifications",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {},
          ),
          ListTile(
            iconColor: CustomTheme.primaryColors.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Image.asset(
              "images/wallet.png",
            ),
            minLeadingWidth: 20.0,
            title: const Text(
              "Payments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {},
          ),
          ListTile(
            iconColor: CustomTheme.primaryColors.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Image.asset(
              "images/favorite_location.png",
            ),
            minLeadingWidth: 20.0,
            title: const Text(
              "Favourite Locations",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              Navigator.pushNamed(context, "favouriteLocation");
            },
          ),
          ListTile(
            iconColor: CustomTheme.primaryColors.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Image.asset(
              "images/Auto_Designed.png",
            ),
            minLeadingWidth: 20.0,
            title: const Text(
              "Ride History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {},
          ),
          ListTile(
            iconColor: CustomTheme.primaryColors.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Image.asset(
              "images/website.png",
            ),
            minLeadingWidth: 20.0,
            title: const Text(
              "Website",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {},
          ),
          ListTile(
            iconColor: CustomTheme.primaryColors.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Image.asset(
              "images/about.png",
            ),
            minLeadingWidth: 20.0,
            title: const Text(
              "About",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {},
          ),
          ListTile(
            iconColor: CustomTheme.primaryColors.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: Image.asset(
              "images/setting.png",
            ),
            minLeadingWidth: 20.0,
            title: const Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, "logoutScreen");
            },
          ),
        ],
      ),
    );
  }
}
