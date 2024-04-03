import 'package:calendar_poc/utils/date_utils.dart' as date_util;
import 'package:flutter/material.dart';
import 'package:new_calendar_poc/utils/events.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  List<String> todos = <String>[];
  TextEditingController controller = TextEditingController();
  Map<DateTime, List<Event>> events = {};

  @override
  void initState() {
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 79.0 * currentDateTime.day);
    super.initState();
  }

  void moveToNextMonth() {
    setState(() {
      currentDateTime = DateTime(
          currentDateTime.year, currentDateTime.month + 1, currentDateTime.day);
      currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
      currentMonthList.sort((a, b) => a.day.compareTo(b.day));
      currentMonthList = currentMonthList.toSet().toList();
      scrollToItem(currentDateTime.day - 4);
    });
  }

  void moveToPreviousMonth() {
    setState(() {
      currentDateTime = DateTime(
          currentDateTime.year, currentDateTime.month - 1, currentDateTime.day);
      currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
      currentMonthList.sort((a, b) => a.day.compareTo(b.day));
      currentMonthList = currentMonthList.toSet().toList();
      scrollToItem(currentDateTime.day - 4);
    });
  }

  Widget backgroundView() {
    return Container(
      decoration: BoxDecoration(
        color: HexColor("#072965"),
        image: DecorationImage(
          image: const AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.lighten),
        ),
      ),
    );
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: SizedBox(
                    height: 400, // adjust these values as needed
                    width: 300,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          currentDateTime = selectedDay;
                          currentMonthList =
                              date_util.DateUtils.daysInMonth(selectedDay);
                          currentMonthList
                              .sort((a, b) => a.day.compareTo(b.day));
                          currentMonthList = currentMonthList.toSet().toList();
                          scrollToItem(selectedDay.day - 4);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          TextButton(
              onPressed: moveToPreviousMonth, child: const Text("Previous")),
          TextButton(onPressed: moveToNextMonth, child: const Text("Next")),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text(
              date_util.DateUtils.months[currentDateTime.month - 1] +
                  ' ' +
                  currentDateTime.year.toString(),
              style: const TextStyle(
                  color: Color.fromARGB(255, 4, 55, 97),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  void scrollToItem(int index) {
    const itemWidth = 80; // replace with your item width
    const itemSpacing = 8; // replace with your spacing between items
    final offset = (itemWidth + itemSpacing) * index;
    scrollController.animateTo(
      offset.toDouble(),
      duration: const Duration(seconds: 1), // change duration as needed
      curve: Curves.easeInOut, // change curve as needed
    );
  }

  Widget hrizontalCapsuleListView() {
    return SizedBox(
      width: width,
      height: 100,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
            });
          },
          child: Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: (currentMonthList[index].day != currentDateTime.day)
                        ? [
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0.6)
                          ]
                        : [
                            HexColor("34baeb"),
                            HexColor("34baeb"),
                            HexColor("34baeb")
                          ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 4,
                    spreadRadius: 2,
                    color: Colors.black12,
                  )
                ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? HexColor("465876")
                                : Colors.white),
                  ),
                  Text(
                    date_util.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? HexColor("465876")
                                : Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget topView() {
    return SizedBox(
      height: height * 0.35,
      width: width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(),
            hrizontalCapsuleListView(),
          ]),
    );
  }

  Widget floatingActionBtn() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        child: Container(
          width: 100,
          height: 100,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    HexColor("ED6184"),
                    HexColor("EF315B"),
                    HexColor("E2042D")
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: const [0.0, 0.5, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        onPressed: () {
          controller.text = "";
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 200,
                    width: 320,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Add Todo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: controller,
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: 'Add your new todo item',
                              hintStyle: TextStyle(color: Colors.white60)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 320,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                todos.add(controller.text);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text("Add Todo"),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Widget todoList() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, height * 0.38, 10, 10),
      width: width,
      height: height * 0.60,
      child: ListView.builder(
          itemCount: todos.length,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              width: width - 20,
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white12,
                        blurRadius: 2,
                        offset: Offset(2, 2),
                        spreadRadius: 3)
                  ]),
              child: Center(
                child: Text(
                  todos[index],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[topView(), todoList()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
