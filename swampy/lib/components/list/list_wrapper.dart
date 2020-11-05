import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:swampy/components/general/column_builder.dart';
import 'package:swampy/components/list/list_element.dart';
import 'package:swampy/components/list/list_category.dart';
import 'package:autotrie/autotrie.dart';

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
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            elevation: 3.0,
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
                contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                hintText: 'Search for a product',
                hintStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          ),
          SizedBox(height: 18.0,),
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
          SizedBox(height: 6.0,),
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
          )
        ],
      ),
    );
  }
}
