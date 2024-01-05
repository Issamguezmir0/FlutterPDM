import 'package:flutter/material.dart';
import 'package:pdm/api/utils/api_image_loader.dart';
import 'package:pdm/model/event.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key, required this.event});
  final Event event;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.8;
    var width = MediaQuery.of(context).size.width * 0.4;

    return Dialog(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    event.title ?? "no title",
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
              ApiImageLoader(
                imageFilename: event.image,
                height: height * 0.3,
                width: width * 0.3,
              ),
              Row(
                children: [
                  const Text(
                    "Date:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(event.date ?? "no - date"),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "description:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(event.description ?? "no - description"),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "details:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(event.details ?? "no - details"),
                ],
              ),
              Row(
                children: [
                  const Text(
                    "Orgeniser:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(event.location ?? "no - orgeniser"),
                ],
              ),
            ]),
      ),
    );
  }
}
