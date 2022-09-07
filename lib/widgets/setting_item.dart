
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final String title;
  final GestureTapCallback? onTap;
  const SettingItem({ Key? key, required this.title, this.onTap, this.leadingIcon, this.leadingIconColor = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: leadingIcon != null ?
            [
              Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: leadingIconColor!.withAlpha(50),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Icon(
                  leadingIcon,
                  size: 24,
                  color: leadingIconColor,
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 14,
              )
            ]
            :
            [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 14,
              )
            ],
          ),
        ),
      ),
    );
  }
}
