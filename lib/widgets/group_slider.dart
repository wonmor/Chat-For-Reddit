
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_firebase/pages/chat_room.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/group_box.dart';
import 'package:flutter/material.dart';

class GroupSlider extends StatelessWidget {
  const GroupSlider({ Key? key, required this.groups, this.onChanged}) : super(key: key);
  final List groups;
  final Function(int, CarouselPageChangedReason)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
          height: 230,
          enlargeCenterPage: true,
          // disableCenter: true,
          viewportFraction: .7,
          onPageChanged: onChanged,
        ),
        items: List.generate(
          groups.length, 
          (index) => GroupBox(gruopData: groups[index], 
            bgColor: itemColors[index % 10],
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: 
                (context) => ChatRoomPage(roomData: groups[index],), fullscreenDialog: true));
            },
          )
        ),
    );
  }
}
