import 'package:flutter/material.dart';

const selectedColor = Colors.greenAccent;
const unSelectedColor = Colors.grey;

// double search list for selecet or search for some item of list
class DoubleSrearchList extends StatefulWidget {
  const DoubleSrearchList({
    Key? key,
    this.onActions,
    required this.data,
    this.mainBoxHeight,
    this.valueKey,
    this.selectedBoxHeight,
    this.searchHint = 'Search...',
  }) : super(key: key);

  final List<Map> data;
  final String? valueKey;

  // actions on transfering item
  final Function(dynamic selectedData)? onActions;

  final double? mainBoxHeight;
  final double? selectedBoxHeight;
  final String searchHint;

  @override
  State<DoubleSrearchList> createState() => _DoubleSrearchListState();
}

class _DoubleSrearchListState extends State<DoubleSrearchList> {
  List<Map> defaultList1 = [];
  List<Map> defaultList2 = [];

  List<Map> mainList1 = [];
  List<Map> tempList1 = [];

  List<Map> tempList2 = [];
  List<Map> mainList2 = [];

  TextEditingController searchListInputController = TextEditingController();
  TextEditingController selectedListInputController = TextEditingController();

  ScrollController rootScrollController = ScrollController();

  @override
  void initState() {
    defaultList1.addAll(widget.data);
    mainList1.addAll(widget.data);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchListInputController.dispose();
    selectedListInputController.dispose();
    rootScrollController.dispose();
  }

  onTransaction() {
    if (widget.onActions != null) {
      widget.onActions!(mainList2);
    }
  }

  //box
  SizedBox boxListView(
    double boxHeight,
    Color selectedColor,
    Color unSelectedColor,
    List mainData,
    List tempData,
  ) {
    return SizedBox(
      height: boxHeight,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: mainData.isEmpty
            ? const Center(
                child: Text(
                'No Data Found',
                style: TextStyle(color: Colors.grey),
              ))
            : ListView.builder(
                itemCount: mainData.length,
                itemBuilder: (context, index) {
                  Map item = mainData[index];
                  String showValue = widget.valueKey != null
                      ? mainData[index][widget.valueKey]
                      : mainData[index].values.first;
                  final isSelect = tempData.contains(item);
                  final trailingIcon = isSelect
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : null;
                  final color = isSelect ? selectedColor : unSelectedColor;
                  return EmployeeListTileWidget(
                    isSelected: isSelect,
                    showValue: showValue,
                    trailing: trailingIcon,
                    item: item,
                    color: color,
                    onSelectEmployee: (employee) {
                      // final isSelect = tempData.contains(employee);
                      setState(() {
                        // if select add item to temo else remove from temp
                        isSelect
                            ? tempData.remove(employee)
                            : tempData.add(employee);
                      });
                    },
                  );
                },
              ),
      ),
    );
  }

  // search in list
  inputOnChange(val, mainData, defaultData) {
    mainData.clear();
    if (val.isEmpty) {
      setState(() {
        mainData.addAll(defaultData);
      });
      return;
    }
    if (widget.valueKey != null) {
      for (var element in defaultData) {
        if (element[widget.valueKey].toString().contains(val)) {
          mainData.add(element);
        }
      }
    } else {
      for (var element in defaultData) {
        if (element.values.contains(val)) {
          mainData.add(element);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isPhoneOrTablet = constraints.maxWidth < 900;
      final direction = Directionality.of(context);
      final flexAlignment =
          isPhoneOrTablet ? CrossAxisAlignment.center : CrossAxisAlignment.end;
      final flexDirection = isPhoneOrTablet ? Axis.vertical : Axis.horizontal;
      final inputFlexMeasure = isPhoneOrTablet ? 0 : 1;
      const boxHeight = 190.0;
      return SingleChildScrollView(
        controller: rootScrollController,
        child: Flex(
            crossAxisAlignment: flexAlignment,
            direction: flexDirection,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: inputFlexMeasure,
                child: Column(
                  children: [
                    // main box
                    SizedBox(
                      // serach input
                      child: CustomSearchFeild(
                          textEditingController: searchListInputController,
                          hint: widget.searchHint,
                          // search in main list
                          onChanged: (val) async {
                            inputOnChange(val, mainList1, defaultList1);
                          }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // main list box
                    boxListView(
                      boxHeight,
                      selectedColor,
                      unSelectedColor,
                      mainList1,
                      tempList1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  width: isPhoneOrTablet ? 200 : 50,
                  height: isPhoneOrTablet ? 50 : 200,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isPhoneOrTablet ? 4 : 1,
                    // icon buttons for transfering actions
                    children: [
                      IconButton(
                          // move all item to to selection temp list
                          onPressed: () {
                            if (mainList1.isNotEmpty &&
                                defaultList1.isNotEmpty) {
                              tempList1 = [];
                              tempList2 = [];
                              for (var element in mainList1) {
                                if (!mainList2.contains(element)) {
                                  mainList2.add(element);
                                  defaultList2.add(element);
                                }
                              }
                              for (var element in mainList2) {
                                if (mainList1.contains(element)) {
                                  mainList1.remove(element);
                                  defaultList1.remove(element);
                                }
                              }
                              setState(() {});
                            }
                            onTransaction();
                          },
                          icon: direction == TextDirection.ltr
                              ? Icon(isPhoneOrTablet
                                  ? Icons.keyboard_double_arrow_down_rounded
                                  : Icons.keyboard_double_arrow_right_rounded)
                              : Icon(isPhoneOrTablet
                                  ? Icons.keyboard_double_arrow_down_rounded
                                  : Icons.keyboard_double_arrow_left_rounded)),
                      IconButton(
                          //remove selceted item from main and add to selction list
                          onPressed: () {
                            setState(() {
                              if (tempList1.isNotEmpty &&
                                  mainList1.isNotEmpty) {
                                for (var e in [...tempList1]) {
                                  if (!mainList2.contains(e)) {
                                    mainList2.add(e);
                                  }
                                  if (!defaultList2.contains(e)) {
                                    defaultList2.add(e);
                                  }
                                  if (mainList1.contains(e)) {
                                    mainList1.remove(e);
                                  }
                                  if (defaultList1.contains(e)) {
                                    defaultList1.remove(e);
                                  }
                                }
                              }
                            });
                            setState(() {
                              tempList1 = [];
                              tempList2 = [];
                            });
                            onTransaction();
                          },
                          icon: direction == TextDirection.ltr
                              ? Icon(isPhoneOrTablet
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_right_rounded)
                              : Icon(isPhoneOrTablet
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_left_rounded)),
                      IconButton(
                          //remove selceted item from selection temp list and add to main unselcted list
                          onPressed: () {
                            setState(() {
                              if (tempList2.isNotEmpty &&
                                  mainList2.isNotEmpty) {
                                for (var e in [...tempList2]) {
                                  if (!mainList1.contains(e)) {
                                    mainList1.add(e);
                                  }
                                  if (!defaultList1.contains(e)) {
                                    defaultList1.add(e);
                                  }

                                  if (mainList2.contains(e)) {
                                    mainList2.remove(e);
                                  }
                                  if (defaultList2.contains(e)) {
                                    defaultList2.remove(e);
                                  }
                                }
                              }
                            });
                            setState(() {
                              tempList1 = [];
                              tempList2 = [];
                            });
                            onTransaction();
                          },
                          icon: direction == TextDirection.ltr
                              ? Icon(isPhoneOrTablet
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_left_rounded)
                              : Icon(isPhoneOrTablet
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_right_rounded)),
                      IconButton(
                          // move all item from temp selection list to main list
                          onPressed: () {
                            // setState(() {
                            if (mainList2.isNotEmpty &&
                                defaultList2.isNotEmpty) {
                              tempList2 = [];
                              tempList1 = [];
                              for (var element in mainList2) {
                                if (!mainList1.contains(element)) {
                                  mainList1.add(element);
                                  defaultList1.add(element);
                                }
                              }
                              for (var element in mainList1) {
                                if (mainList2.contains(element)) {
                                  mainList2.remove(element);
                                  defaultList2.remove(element);
                                }
                              }
                              setState(() {});
                            }
                            onTransaction();
                          },
                          icon: direction == TextDirection.ltr
                              ? Icon(isPhoneOrTablet
                                  ? Icons.keyboard_double_arrow_up_rounded
                                  : Icons.keyboard_double_arrow_left_rounded)
                              : Icon(isPhoneOrTablet
                                  ? Icons.keyboard_double_arrow_up_rounded
                                  : Icons.keyboard_double_arrow_right_rounded)),
                    ],
                  )),
              Expanded(
                flex: isPhoneOrTablet ? 0 : 1,
                child: Column(
                  children: [
                    SizedBox(
                      // custom searching input
                      child: CustomSearchFeild(
                          textEditingController: selectedListInputController,
                          hint: widget.searchHint,
                          // searching algorithm
                          onChanged: (val) {
                            inputOnChange(val, mainList2, defaultList2);
                          }),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // selection box
                    boxListView(
                      boxHeight,
                      selectedColor,
                      unSelectedColor,
                      mainList2,
                      tempList2,
                    ),
                  ],
                ),
              )
            ]),
      );
    });
  }
}

// custom item widget
class EmployeeListTileWidget extends StatelessWidget {
  final String? showValue;
  final Map? item;
  final bool isSelected;
  final Color color;
  final Widget? trailing;
  final ValueChanged onSelectEmployee;

  const EmployeeListTileWidget({
    Key? key,
    required this.showValue,
    required this.item,
    required this.color,
    required this.trailing,
    required this.isSelected,
    required this.onSelectEmployee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (p0, p1) {
      return SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
          child: Card(
            color: color,
            child: ListTile(
              onTap: () => onSelectEmployee(item),
              title: Text(
                showValue ?? "",
                style: const TextStyle(fontSize: 11),
              ),
              trailing: trailing,
            ),
          ),
        ),
      );
    });
  }
}

// custom search widget
class CustomSearchFeild extends StatelessWidget {
  const CustomSearchFeild({
    Key? key,
    required this.hint,
    required this.onChanged,
    required this.textEditingController,
  }) : super(key: key);
  final String hint;
  final Function(String) onChanged;

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        autocorrect: false,
        initialValue: textEditingController.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 11),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
