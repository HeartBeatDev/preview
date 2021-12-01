import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {

  final String _url;
  final double? width;
  final double? height;

  Avatar(String url, {this.width, this.height}) : this._url = url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          image: DecorationImage(image: NetworkImage(_url), fit: BoxFit.cover)
      ),
    );
  }

  factory Avatar.profile(String url, {Widget? editButton}) {
    return Avatar(
      url,
      width: 100,
      height: 100
    );
  }
}