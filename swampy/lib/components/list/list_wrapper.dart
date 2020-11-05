import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_category.dart';
import 'package:autotrie/autotrie.dart';
import 'package:circular_check_box/circular_check_box.dart';

//TODO: There's a bug where if you resize, the filtering doesn't work
class ListWrapper extends StatefulWidget {
  final List<String> titles;
  List<ListElement> elements;

  ListWrapper({@required this.titles, @required this.elements});

  @override
  _ListWrapperState createState() => _ListWrapperState();
}

class _ListWrapperState extends State<ListWrapper> {
  List<Sort> sorts;
  List<ListElement> original;
  AutoComplete searchComplete = AutoComplete(engine: SortEngine.configMulti(Duration(seconds: 1), 15, 0.5, 0.5));
  HashMap<String, ListElement> lookupTable = HashMap<String, ListElement>();
  bool showFilterMenu = false;
  RangeValues inventoryValues = const RangeValues(0, 80);
  RangeValues soldValues = const RangeValues(0, 60);
  Map<String, bool> typesValues = {'Hat' : true, 'Shirt' : true, 'Pants' : true, 'Shoes' : true};

  @override
  void initState() {
    sorts = List.generate(widget.titles.length, (index) => Sort.none);
    original = List.from(widget.elements);
    for (ListElement element in original) {
      searchComplete.enter(element.items[0].toLowerCase());
      lookupTable[element.items[0].toLowerCase()] = element;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Column(
        children: [
          Stack(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: sizingInformation.deviceScreenType == DeviceScreenType.mobile ?
                    MediaQuery.of(context).size.height - (55 + 24 + 28.42 + 21.6) : MediaQuery.of(context).size.height - (70 + 24 + 28.42 + 21.6)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 100,),
                    Flexible(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: sizingInformation.deviceScreenType == DeviceScreenType.mobile ?
                              MediaQuery.of(context).size.height - (55 + 24 + 28.42 + 46.6) : MediaQuery.of(context).size.height - (70 + 24 + 28.42 + 46.6)
                          ),
                          child: ColumnBuilder(
                              itemCount: widget.elements.length,
                              itemBuilder: (context, index) => AnimatedCrossFade(
                                firstChild: widget.elements[index],
                                secondChild: SizedBox.shrink(),
                                crossFadeState: widget.elements[index].visible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                duration: Duration(milliseconds: 200),
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 72.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(widget.titles.length, (index) {
                      return InkWell(
                        child: ListCategory(name: widget.titles[index], sort: sorts[index]),
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < sorts.length; i++) {
                              if (i != index) sorts[i] = Sort.none;
                            }
                            if (sorts[index] == Sort.none) {
                              sorts[index] = Sort.descending;
                              widget.elements.sort((a, b) {
                                try {
                                  return int.parse(a.items[index]) < int.parse(b.items[index]) ? -1 : 1;
                                } catch (e) {
                                  return a.items[index].compareTo(b.items[index]);
                                }
                              });
                            }
                            else if (sorts[index] == Sort.descending) {
                              sorts[index] = Sort.ascending;
                              widget.elements.sort((a, b) {
                                try {
                                  return int.parse(a.items[index]) < int.parse(b.items[index]) ? 1 : -1;
                                } catch (e) {
                                  return b.items[index].compareTo(a.items[index]);
                                }
                              });
                            }
                            else if (sorts[index] == Sort.ascending) {
                              sorts[index] = Sort.none;
                              widget.elements = original;
                            }
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    elevation: 3.0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5
                      ),
                      child: TextFormField(
                        onChanged: (val) {
                          final matches = searchComplete.suggest(val.toLowerCase());
                          for (ListElement element in original) {
                            setState(() {
                              element.visible = false;
                            });
                          }
                          for (String match in matches) {
                            setState(() {
                              lookupTable[match].visible = true;
                            });
                          }
                        },
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Icon(Icons.search_rounded),
                          ),
                          alignLabelWithHint: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(32.0)
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(32.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(32.0)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(32.0)
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                          hintText: 'Search for a product',
                          hintStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        elevation: 3.0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showFilterMenu = !showFilterMenu;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0, top: 12.0, bottom: 12.0, right: 14.0),
                            child: Row(
                              children: [
                                Text('Filters', style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal),),
                                SizedBox(width: 4.0,),
                                Icon(showFilterMenu ?  Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.grey[500],)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        elevation: 3.0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.2,
                              maxHeight: 300
                          ),
                          child: showFilterMenu ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  height: 18.0,
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Text('Inventory', style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: RangeSlider(
                                    values: inventoryValues,
                                    min: 0,
                                    max: 80,
                                    divisions: 8,
                                    labels: RangeLabels(
                                      inventoryValues.start.round().toString(),
                                      inventoryValues.end.round().toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        inventoryValues = values;
                                        for (ListElement element in original) {
                                          element.visible = false;
                                        }
                                        for (ListElement element in original) {
                                          if (
                                          int.parse(element.items[1]) >= inventoryValues.start && int.parse(element.items[1]) <= inventoryValues.end &&
                                          int.parse(element.items[4]) >= soldValues.start && int.parse(element.items[4]) <= soldValues.end)
                                          {
                                            element.visible = true;
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Text('# Sold', style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: RangeSlider(
                                    values: soldValues,
                                    activeColor: Theme.of(context).primaryColor,
                                    min: 0,
                                    max: 60,
                                    divisions: 6,
                                    labels: RangeLabels(
                                      soldValues.start.round().toString(),
                                      soldValues.end.round().toString(),
                                    ),
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        soldValues = values;
                                        for (ListElement element in original) {
                                          element.visible = false;
                                        }
                                        for (ListElement element in original) {
                                          if (
                                          int.parse(element.items[1]) >= inventoryValues.start && int.parse(element.items[1]) <= inventoryValues.end &&
                                          int.parse(element.items[4]) >= soldValues.start && int.parse(element.items[4]) <= soldValues.end)
                                          {
                                            element.visible = true;
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                    child: Text('Type', style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: CheckboxListTile(
                                    checkColor: Theme.of(context).primaryColor,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text('Hat'),
                                    value: typesValues['Hat'],
                                    onChanged: (newValue) {
                                      setState(() {
                                        typesValues['Hat'] = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: CheckboxListTile(
                                    checkColor: Theme.of(context).primaryColor,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text('Shirt'),
                                    value: typesValues['Shirt'],
                                    onChanged: (newValue) {
                                      setState(() {
                                        typesValues['Shirt'] = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: CheckboxListTile(
                                    checkColor: Theme.of(context).primaryColor,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text('Pants'),
                                    value: typesValues['Pants'],
                                    onChanged: (newValue) {
                                      setState(() {
                                        typesValues['Pants'] = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: CheckboxListTile(
                                    checkColor: Theme.of(context).primaryColor,
                                    activeColor: Theme.of(context).primaryColor,
                                    title: Text('Shoes'),
                                    value: typesValues['Shoes'],
                                    onChanged: (newValue) {
                                      setState(() {
                                        typesValues['Shoes'] = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  height: 12.0,
                                ),
                              ),
                            ],
                          ) : SizedBox.shrink(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
