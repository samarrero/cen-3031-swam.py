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
      builder: (context, sizingInformation) => Column(
        children: [
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
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: sizingInformation.deviceScreenType == DeviceScreenType.mobile ?
                MediaQuery.of(context).size.height - (55 + 24 + 28.42 + 46.6) : MediaQuery.of(context).size.height - (70 + 24 + 28.42 + 46.6)
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
