import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_category.dart';

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

  @override
  void initState() {
    sorts = List.generate(widget.titles.length, (index) => Sort.none);
    original = List.from(widget.elements);
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
                      SizedBox(height: 100,),
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
                                  firstChild: visibleElements[index],
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
                                    return double.parse(a.items[index]) < double.parse(b.items[index]) ? -1 : 1;
                                  } catch (e) {
                                    return a.items[index].compareTo(b.items[index]);
                                  }
                                });
                              }
                              else if (sorts[index] == Sort.descending) {
                                sorts[index] = Sort.ascending;
                                visibleElements.sort((a, b) {
                                  try {
                                    return double.parse(a.items[index]) < double.parse(b.items[index]) ? 1 : -1;
                                  } catch (e) {
                                    return b.items[index].compareTo(a.items[index]);
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
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          elevation: 3.0,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: sizingInformation.deviceScreenType == DeviceScreenType.mobile ? MediaQuery.of(context).size.width - 56 : MediaQuery.of(context).size.width - 256
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
                                    if (int.parse(lookupTable[match].items[filter]) < sliderValues[filter].start || int.parse(lookupTable[match].items[filter]) > sliderValues[filter].end) {
                                      allGood = false;
                                      break;
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
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              elevation: 3.0,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                constraints: BoxConstraints(
                                  maxWidth: sizingInformation.deviceScreenType == DeviceScreenType.desktop ? 300 : sizingInformation.deviceScreenType == DeviceScreenType.tablet ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width,
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
                                              divisions: maxSliderValues[filter] ~/ 10,
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
                                                      if (int.parse(lookupTable[match].items[matchFilter]) < sliderValues[matchFilter].start || int.parse(lookupTable[match].items[matchFilter]) > sliderValues[matchFilter].end) {
                                                        allGood = false;
                                                        break;
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
                                    for (String categoryName in widget.filterCategories.keys) ConstrainedBox(
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
                  ],
                ),
              ],
            ),
            child: SingleChildScrollView(
                child: ColumnBuilder(
                    itemCount: widget.elements.length,
                    itemBuilder: (context, index) => widget.elements[index]
                )
            ),
          )
        ],
      ),
    );
  }
}
