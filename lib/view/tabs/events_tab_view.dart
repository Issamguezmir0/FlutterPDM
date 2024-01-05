import 'package:flutter/material.dart';
import 'package:pdm/api/response/status.dart';
import 'package:pdm/api/utils/api_image_loader.dart';
import 'package:pdm/model/event.dart';
import 'package:pdm/utils/dimensions.dart';
import 'package:pdm/utils/theme/theme_styles.dart';
import 'package:pdm/view/views/events/event_details.dart';
import 'package:pdm/view/widgets/custom_error_widget.dart';
import 'package:pdm/view/widgets/loading_widget.dart';
import 'package:pdm/view_model/events_view_model.dart';
import 'package:provider/provider.dart';

class EventsTabView extends StatefulWidget {
  const EventsTabView({Key? key}) : super(key: key);

  @override
  State<EventsTabView> createState() => _EventsTabViewState();
}

class _EventsTabViewState extends State<EventsTabView> {
  EventViewModel viewModel = EventViewModel();

  loadData() {
    viewModel.getAll();
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: Dimensions.bigPadding,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "List of events",
                    style: TextStyle(fontSize: 45),
                  ),
                ),
                const SizedBox(width: 30),
                FilledButton(
                  onPressed: () => loadData(),
                  child: const Text("Refresh list"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ChangeNotifierProvider(
              create: (context) => viewModel,
              child: Consumer<EventViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.apiResponse.status == Status.completed) {
                    return _buildeventsTableWidget();
                  } else if (viewModel.apiResponse.status == Status.loading) {
                    return const LoadingWidget();
                  } else {
                    return const CustomErrorWidget();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildeventsTableWidget() {
    return Card(
      elevation: 5,
      child: ClipRect(
        child: Table(
          border: TableBorder.all(
              borderRadius: Dimensions.roundedBorderMedium,
              color: Colors.black.withOpacity(0.15)),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Styles.primaryColor,
                borderRadius: Dimensions.roundedBorderTopMedium,
              ),
              children: [
                _makeTitleTableRowWidget(text: "Image"),
                _makeTitleTableRowWidget(text: "Title"),
                _makeTitleTableRowWidget(text: "Organisateur"),
                _makeTitleTableRowWidget(text: "Description"),
                _makeTitleTableRowWidget(text: "date"),
                _makeTitleTableRowWidget(text: "is Free"),
                _makeTitleTableRowWidget(text: "price"),
                _makeTitleTableRowWidget(text: "Actions"),
              ],
            ),
            for (Event event in viewModel.itemList) _buildeventTableRow(event)
          ],
        ),
      ),
    );
  }

  Widget _makeTitleTableRowWidget({required String text}) {
    return Center(
      child: Padding(
        padding: Dimensions.bigPadding,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  TableRow _buildeventTableRow(Event event) {
    return TableRow(
      children: [
        _makeImageTableRowWidget(text: event.image),
        _makeTableRowWidget(text: event.title),
        _makeTableRowWidget(text: event.organisateur),
        _makeTableRowWidget(text: event.description),
        _makeTableRowWidget(text: event.date),
        _makeIsFreeTableRowWidget(text: event.isFree.toString()),
        _makeTableRowWidget(text: event.price.toString()),
        Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => EventDetails(
                        event: event,
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      noticeColor.withOpacity(0.3),
                    ),
                  ),
                  icon: const Icon(Icons.remove_red_eye, color: noticeColor),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      warningColor.withOpacity(0.3),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: warningColor),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () {
                    /*
                    event.isBanned = !event.isBanned;
                    eventViewModel.update(event: event).then(
                          (value) => loadData(),
                        );
                */
                  },
                  icon: Icon(
                    Icons.block,
                    color: dangerColor,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _makeTableRowWidget({required String? text}) {
    return Center(
      child: Padding(
        padding: Dimensions.bigPadding,
        child: Text("$text"),
      ),
    );
  }

  Widget _makeImageTableRowWidget({required String? text}) {
    return Center(
      child: Padding(
        padding: Dimensions.bigPadding,
        child: ApiImageLoader(imageFilename: text),
      ),
    );
  }

  Widget _makeIsFreeTableRowWidget({required String? text}) {
    return Center(
      child: Padding(
        padding: Dimensions.bigPadding,
        child: Chip(
            label: Text(text == "true" ? "Free" : "Paid"),
            backgroundColor: text == "true"
                ? Color.fromARGB(255, 145, 228, 148)
                : const Color.fromARGB(255, 241, 147, 140),
            shape: const StadiumBorder(),
            side: const BorderSide(style: BorderStyle.none)),
      ),
    );
  }
}
