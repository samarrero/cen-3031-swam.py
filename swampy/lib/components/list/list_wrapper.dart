import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/general/circular_checkbox.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/general/dropdown.dart' as Custom;
import 'package:swampy/components/list/list_card.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_category.dart';
import 'package:autotrie/autotrie.dart';
import 'package:intl/intl.dart';

class ListWrapper extends StatefulWidget {
  final List<String> titles;
  final List<ListElement> elements;
  final List<int> filterSliders;
  final List<int> filterCategories;
  final String searchType;
  final int primaryKey, secondaryKey;

  ListWrapper({@required this.titles, @required this.elements, this.filterSliders, this.filterCategories, this.searchType, this.primaryKey = 0, this.secondaryKey = 0});

  @override
  _ListWrapperState createState() => _ListWrapperState();
}

class _ListWrapperState extends State<ListWrapper> {
  List<Sort> sorts;
  List<ListElement> visibleElements;
  AutoComplete searchComplete = AutoComplete(engine: SortEngine.configMulti(Duration(seconds: 1), 15, 0.5, 0.5));
  Map<String, ListElement> lookupTable = Map<String, ListElement>();
  TextEditingController searchController = TextEditingController();
  bool showFilterMenu = false;
  bool showSortingMenu = false;
  String sortingValue = 'None';
  String sortingDirection = 'Ascending';
  Map<String, int> sortingIndex = Map<String, int>();
  List<double> maxSliderValues;
  List<RangeValues> sliderValues;
  Map<String, Map<String, bool>> categoryValues = Map<String, Map<String, bool>>();

  @override
  void initState() {
    sorts = List.generate(widget.titles.length, (index) => Sort.none);
    visibleElements = List.from(widget.elements);
    sliderValues = List<RangeValues>(widget.titles.length);
    maxSliderValues = List<double>.generate(widget.titles.length, (index) => 0);
    for (ListElement element in visibleElements) {
      searchComplete.enter(element.items[0].toLowerCase());
      lookupTable[element.items[0].toLowerCase()] = element;
      for (int i = 0; i < element.items.length; i++) {
        if (widget.filterSliders.contains(i)) {
          try {
            maxSliderValues[i] = double.parse(element.items[i]) > maxSliderValues[i] ? double.parse(element.items[i]) : maxSliderValues[i];
          } catch (e) {
            maxSliderValues[i] = double.parse(element.items[i].substring(1)) > maxSliderValues[i] ? double.parse(element.items[i].substring(1)) : maxSliderValues[i];
          }
        }
      }
    }
    for (int filter in widget.filterSliders) {
      maxSliderValues[filter] = ((maxSliderValues[filter] / 10.0).ceil() * 10).toDouble();
      sliderValues[filter] = RangeValues(0, maxSliderValues[filter]);
    }
    sortingIndex['None'] = -1;
    for (int i = 0; i < widget.titles.length; i++) {
      sortingIndex[widget.titles[i]] = i;
      if (widget.filterCategories.contains(i)) {
        categoryValues[widget.titles[i]] = Map<String, bool>();
        for (ListElement element in visibleElements) {
          categoryValues[widget.titles[i]][element.items[i]] = true;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => SingleChildScrollView(
        child: Column(
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
                      SizedBox(height: sizingInformation.deviceScreenType == DeviceScreenType.desktop ? 100 : 72),
                      Flexible(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: sizingInformation.deviceScreenType == DeviceScreenType.mobile ?
                                MediaQuery.of(context).size.height - (55 + 24 + 28.42 + 46.6) : MediaQuery.of(context).size.height - (70 + 24 + 28.42 + 46.6)
                            ),
                            child: ColumnBuilder(
                                itemCount: visibleElements.length,
                                itemBuilder: (context, index) => AnimatedCrossFade(
                                  firstChild: sizingInformation.deviceScreenType != DeviceScreenType.desktop ?
                                  ListCard(
                                      primaryKey: widget.primaryKey,
                                      secondaryKey: widget.secondaryKey,
                                      attributes: visibleElements[index],
                                      descriptors: widget.titles,
                                  ) : visibleElements[index],
                                  secondChild: SizedBox.shrink(),
                                  crossFadeState: visibleElements[index].visible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                  duration: Duration(milliseconds: 200),
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sizingInformation.deviceScreenType == DeviceScreenType.desktop ?
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
                                visibleElements.sort((a, b) {
                                  try {
                                    return reformatDateTime(a.items[index]).isBefore(reformatDateTime(b.items[index])) ? -1 : 1; //date
                                  }
                                  catch (e) {
                                    try {
                                      return double.parse(a.items[index]) < double.parse(b.items[index]) ? -1 : 1; //number
                                    }
                                    catch (e) {
                                      try {
                                        return double.parse(a.items[index].substring(1)) < double.parse(b.items[index].substring(1)) ? -1 : 1; //$amount
                                      } catch (e) {
                                        return a.items[index].compareTo(b.items[index]); //string
                                      }
                                    }
                                  }
                                });
                              }
                              else if (sorts[index] == Sort.descending) {
                                sorts[index] = Sort.ascending;
                                visibleElements.sort((a, b) {
                                  try {
                                    return reformatDateTime(a.items[index]).isBefore(reformatDateTime(b.items[index])) ? 1 : -1; //date
                                  } catch (e) {
                                    try {
                                      return double.parse(a.items[index]) < double.parse(b.items[index]) ? 1 : -1; //number
                                    } catch (e) {
                                      try {
                                        return double.parse(a.items[index].substring(1)) < double.parse(b.items[index].substring(1)) ? 1 : -1; //$amount
                                      } catch (e) {
                                        return b.items[index].compareTo(a.items[index]); //string
                                      }
                                    }
                                  }
                                });
                              }
                              else if (sorts[index] == Sort.ascending) {
                                sorts[index] = Sort.none;
                                visibleElements = widget.elements;
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ) : SizedBox.shrink(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: sizingInformation.deviceScreenType != DeviceScreenType.mobile ? MediaQuery.of(context).size.width - 200 : MediaQuery.of(context).size.width,
                      maxWidth: sizingInformation.deviceScreenType != DeviceScreenType.mobile ? MediaQuery.of(context).size.width - 200 : MediaQuery.of(context).size.width
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Positioned(
                        left: 0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          elevation: 3.0,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: sizingInformation.deviceScreenType == DeviceScreenType.desktop ? MediaQuery.of(context).size.width * 0.5 : sizingInformation.deviceScreenType == DeviceScreenType.tablet ? MediaQuery.of(context).size.width - 200 - 184 : MediaQuery.of(context).size.width - 184
                            ),
                            child: TextFormField(
                              controller: searchController,
                              onChanged: (val) {
                                final matches = searchComplete.suggest(val.toLowerCase());
                                for (ListElement element in visibleElements) {
                                  setState(() {
                                    element.visible = false;
                                  });
                                }
                                for (String match in matches) {
                                  bool allGood = true;
                                  for (int filter in widget.filterSliders) {
                                    try {
                                      if (double.parse(lookupTable[match].items[filter]) < sliderValues[filter].start || double.parse(lookupTable[match].items[filter]) > sliderValues[filter].end) {
                                        allGood = false;
                                        break;
                                      }
                                    } catch (e) {
                                      if (double.parse(lookupTable[match].items[filter].substring(1)) < sliderValues[filter].start || double.parse(lookupTable[match].items[filter].substring(1)) > sliderValues[filter].end) {
                                        allGood = false;
                                        break;
                                      }
                                    }
                                  }
                                  for (int filterCategory in widget.filterCategories) {
                                    for (String key in categoryValues.keys) {
                                      for (String mapping in categoryValues[key].keys) {
                                        if (lookupTable[match].items[filterCategory] == mapping && !categoryValues[widget.titles[filterCategory]][mapping]) {
                                          allGood = false;
                                          break;
                                        }
                                      }
                                    }
                                  }
                                  setState(() {
                                    if (allGood)
                                    {
                                      lookupTable[match].visible = true;
                                    }
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
                                hintText: 'Search for a${widget.searchType}',
                                hintStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                      sizingInformation.deviceScreenType != DeviceScreenType.desktop ?
                      Padding(
                        padding: const EdgeInsets.only(right: 64.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth: 111
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                elevation: 3.0,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showSortingMenu = !showSortingMenu;
                                      if (showSortingMenu) {
                                        showFilterMenu = false;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0, right: 12.0),
                                    child: Icon(Icons.sort_rounded, color: Colors.grey[600]),
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
                                    maxWidth: sizingInformation.deviceScreenType == DeviceScreenType.desktop ? MediaQuery.of(context).size.width * 0.3 : sizingInformation.deviceScreenType == DeviceScreenType.tablet ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.8,
                                    maxHeight: 800
                                ),
                                child: showSortingMenu ? Padding(
                                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0, bottom: 12.0),
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    alignment: WrapAlignment.spaceBetween,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    children: [
                                      Text('Sort by: ', style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),),
                                      SizedBox(height: 6.0),
                                      Custom.DropdownButton(
                                        elevation: 3,
                                        hint: Text(sortingValue, style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold)),
                                        value: sortingValue,
                                        items: (['None'] + widget.titles).map((title) {
                                          return Custom.DropdownMenuItem(
                                            value: title,
                                            child: Text(title, style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold)),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            sortingValue = value;
                                            int index = sortingIndex[sortingValue];
                                            for (int i = 0; i < sorts.length; i++) {
                                              if (i != index) sorts[i] = Sort.none;
                                            }
                                            if (index == -1) {
                                              visibleElements = widget.elements;
                                            } else if (sortingDirection == 'Descending') {
                                              sorts[index] = Sort.descending;
                                              visibleElements.sort((a, b) {
                                                try {
                                                  return reformatDateTime(a.items[index]).isBefore(reformatDateTime(b.items[index])) ? 1 : -1; //date
                                                } catch (e) {
                                                  try {
                                                    return double.parse(a.items[index]) < double.parse(b.items[index]) ? 1 : -1; //number
                                                  } catch (e) {
                                                    try {
                                                      return double.parse(a.items[index].substring(1)) < double.parse(b.items[index].substring(1)) ? 1 : -1; //$amount
                                                    } catch (e) {
                                                      return b.items[index].compareTo(a.items[index]); //string
                                                    }
                                                  }
                                                }
                                              });
                                            } else if (sortingDirection == 'Ascending') {
                                              sorts[index] = Sort.ascending;
                                              visibleElements.sort((a, b) {
                                                try {
                                                  return reformatDateTime(a.items[index]).isBefore(reformatDateTime(b.items[index])) ? -1 : 1; //date
                                                }
                                                catch (e) {
                                                  try {
                                                    return double.parse(a.items[index]) < double.parse(b.items[index]) ? -1 : 1; //number
                                                  }
                                                  catch (e) {
                                                    try {
                                                      return double.parse(a.items[index].substring(1)) < double.parse(b.items[index].substring(1)) ? -1 : 1; //$amount
                                                    } catch (e) {
                                                      return a.items[index].compareTo(b.items[index]); //string
                                                    }
                                                  }
                                                }
                                              });
                                            }
                                          });
                                        },
                                      ),
                                      Custom.DropdownButton(
                                        elevation: 3,
                                        hint: Text(sortingDirection, style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold)),
                                        value: sortingDirection,
                                        items: [
                                          Custom.DropdownMenuItem(
                                            // height: 43.0,
                                            value: 'Ascending',
                                            child: Text('Ascending', style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold)),
                                          ),
                                          Custom.DropdownMenuItem(
                                            // height: 43.0,
                                            value: 'Descending',
                                            child: Text('Descending', style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold)),
                                          )
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            sortingDirection = value;
                                            int index = sortingIndex[sortingValue];
                                            if (index != -1 && sortingDirection == 'Descending') {
                                              sorts[index] = Sort.descending;
                                            } else if (index != -1) {
                                              sorts[index] = Sort.ascending;
                                            }
                                            for (int i = 0; i < sorts.length; i++) {
                                              if (i != index) sorts[i] = Sort.none;
                                            }
                                            if (index == -1) {
                                              visibleElements = widget.elements;
                                            } else if (sorts[index] == Sort.descending) {
                                              visibleElements.sort((a, b) {
                                                try {
                                                  return reformatDateTime(a.items[index]).isBefore(reformatDateTime(b.items[index])) ? 1 : -1; //date
                                                } catch (e) {
                                                  try {
                                                    return double.parse(a.items[index]) < double.parse(b.items[index]) ? 1 : -1; //number
                                                  } catch (e) {
                                                    try {
                                                      return double.parse(a.items[index].substring(1)) < double.parse(b.items[index].substring(1)) ? 1 : -1; //$amount
                                                    } catch (e) {
                                                      return b.items[index].compareTo(a.items[index]); //string
                                                    }
                                                  }
                                                }
                                              });
                                            } else if (sorts[index] == Sort.ascending) {
                                              visibleElements.sort((a, b) {
                                                try {
                                                  return reformatDateTime(a.items[index]).isBefore(reformatDateTime(b.items[index])) ? -1 : 1; //date
                                                }
                                                catch (e) {
                                                  try {
                                                    return double.parse(a.items[index]) < double.parse(b.items[index]) ? -1 : 1; //number
                                                  }
                                                  catch (e) {
                                                    try {
                                                      return double.parse(a.items[index].substring(1)) < double.parse(b.items[index].substring(1)) ? -1 : 1; //$amount
                                                    } catch (e) {
                                                      return a.items[index].compareTo(b.items[index]); //string
                                                    }
                                                  }
                                                }
                                              });
                                            }
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ) : SizedBox.shrink(),
                              ),
                            )
                          ],
                        ),
                      ) : SizedBox.shrink(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 111
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              elevation: 3.0,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    showFilterMenu = !showFilterMenu;
                                    if (showFilterMenu) {
                                      showSortingMenu = false;
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(left: sizingInformation.deviceScreenType == DeviceScreenType.desktop ? 24.0 : 12.0, top: 12.0, bottom: 12.0, right: sizingInformation.deviceScreenType == DeviceScreenType.desktop ? 14.0 : 12.0),
                                  child:
                                  sizingInformation.deviceScreenType == DeviceScreenType.desktop ? Row(
                                    children: [
                                      Text('Filters', style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal),),
                                      SizedBox(width: 4.0,),
                                      Icon(showFilterMenu ?  Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.grey[500],)
                                    ],
                                  ) : Icon(Icons.filter_list_rounded, color: Colors.grey[600]),
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
                                  maxWidth: sizingInformation.deviceScreenType == DeviceScreenType.desktop ? MediaQuery.of(context).size.width * 0.3 : sizingInformation.deviceScreenType == DeviceScreenType.tablet ? MediaQuery.of(context).size.width * 0.5 : MediaQuery.of(context).size.width * 0.8,
                                  maxHeight: 800
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
                                  for (int filter in widget.filterSliders) ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 800
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                            child: Text(widget.titles[filter], style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: RangeSlider(
                                            values: sliderValues[filter],
                                            min: 0,
                                            max: maxSliderValues[filter],
                                            divisions: maxSliderValues[filter] > 10 ? maxSliderValues[filter] ~/ 10 : maxSliderValues[filter],
                                            labels: RangeLabels(
                                              sliderValues[filter].start.round().toString(),
                                              sliderValues[filter].end.round().toString(),
                                            ),
                                            onChanged: (RangeValues values) {
                                              setState(() {
                                                sliderValues[filter] = values;
                                                final matches = searchComplete.suggest(searchController.text.toLowerCase());
                                                for (ListElement element in visibleElements) {
                                                  element.visible = false;
                                                }
                                                for (String match in matches) {
                                                  bool allGood = true;
                                                  for (int matchFilter in widget.filterSliders) {
                                                    try {
                                                      if (double.parse(lookupTable[match].items[matchFilter]) < sliderValues[matchFilter].start || double.parse(lookupTable[match].items[matchFilter]) > sliderValues[matchFilter].end) {
                                                        allGood = false;
                                                        break;
                                                      }
                                                    } catch (e) {
                                                      if (double.parse(lookupTable[match].items[matchFilter].substring(1)) < sliderValues[matchFilter].start || double.parse(lookupTable[match].items[matchFilter].substring(1)) > sliderValues[matchFilter].end) {
                                                        allGood = false;
                                                        break;
                                                      }
                                                    }
                                                  }
                                                  for (int filterCategory in widget.filterCategories) {
                                                    for (String key in categoryValues.keys) {
                                                      for (String mapping in categoryValues[key].keys) {
                                                        if (lookupTable[match].items[filterCategory] == mapping && !categoryValues[widget.titles[filterCategory]][mapping]) {
                                                          allGood = false;
                                                          break;
                                                        }
                                                      }
                                                    }
                                                  }
                                                  setState(() {
                                                    if (allGood)
                                                    {
                                                      lookupTable[match].visible = true;
                                                    }
                                                  });
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0
                                        )
                                      ],
                                    ),
                                  ),
                                  for (String categoryName in categoryValues.keys) ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 800
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                            child: Text(categoryName, style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),)
                                        ),
                                        SizedBox(
                                          height: 6.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Wrap(
                                            spacing: 8.0,
                                            direction: Axis.horizontal,
                                            children: createCategoryButtons(categoryName),
                                          ),
                                        ),
                                      ],
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DateTime reformatDateTime(String s) {
    var inputFormat = DateFormat('MM/dd/yyyy');
    var date1 = inputFormat.parse(s);

    var outputFormat = DateFormat('yyyy-MM-dd');
    return outputFormat.parse('$date1');
  }

  List<Widget> createCategoryButtons(String categoryName) {
    List<Widget> buttons = List<Widget>();
    for (String categoryValue in categoryValues[categoryName].keys) {
      buttons.add(
          Column(
            children: [
              CircularCheckBox(
                value: categoryValues[categoryName][categoryValue],
                inactiveColor: Colors.grey[300],
                checkColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).primaryColor,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onChanged: (_) {
                  setState(() {
                    categoryValues[categoryName][categoryValue] = !categoryValues[categoryName][categoryValue];
                    final matches = searchComplete.suggest(searchController.text.toLowerCase());
                    for (ListElement element in visibleElements) {
                      element.visible = false;
                    }
                    for (String match in matches) {
                      bool allGood = true;
                      for (int matchFilter in widget.filterSliders) {
                        try {
                          if (double.parse(lookupTable[match].items[matchFilter]) < sliderValues[matchFilter].start || double.parse(lookupTable[match].items[matchFilter]) > sliderValues[matchFilter].end) {
                            allGood = false;
                            break;
                          }
                        } catch (e) {
                          if (double.parse(lookupTable[match].items[matchFilter].substring(1)) < sliderValues[matchFilter].start || double.parse(lookupTable[match].items[matchFilter].substring(1)) > sliderValues[matchFilter].end) {
                            allGood = false;
                            break;
                          }
                        }
                      }
                      for (int filterCategory in widget.filterCategories) {
                        for (String key in categoryValues.keys) {
                          for (String mapping in categoryValues[key].keys) {
                            if (lookupTable[match].items[filterCategory] == mapping && !categoryValues[widget.titles[filterCategory]][mapping]) {
                              allGood = false;
                              break;
                            }
                          }
                        }
                      }
                      setState(() {
                        if (allGood)
                        {
                          lookupTable[match].visible = true;
                        }
                      });
                    }
                  });
                },
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(categoryValue, style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold)),
            ],
          )
      );
    }
    buttons.add(Container(
      height: 18,
    ));
    return buttons;
  }
}
