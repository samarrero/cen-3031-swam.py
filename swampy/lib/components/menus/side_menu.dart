import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(context) => ListView(
      children: [
        MediaQuery.of(context).size.width < 600 ?
        Column(
          children: [
            FlatButton(
              child: ListTile(
                leading: Icon(Icons.account_circle, color: Colors.black),
                title: Text('Account', style: Theme.of(context).textTheme.headline6),
              ),
              onPressed: () {
                //TODO
              },
            ),
            Divider(
              color: Colors.grey.shade700,
              thickness: 1.0,
            ),
            SizedBox(
              height: 8.0,
            ),
          ],
        ) : SizedBox.shrink(),
        FlatButton(
            child: ListTile(
              leading: Icon(Icons.home_rounded, color: Colors.black),
              title: Text('Home', style: Theme.of(context).textTheme.headline6),
              selected: true,
              selectedTileColor: Colors.grey.withOpacity(0.3),
            ),
            onPressed: () {
              //TODO
            },
        ),
        FlatButton(
            child: ListTile(
              leading: Icon(Icons.widgets_rounded, color: Colors.black),
              title: Text('Products', style: Theme.of(context).textTheme.headline6,),
              selected: false,
              selectedTileColor: Colors.grey.withOpacity(0.3),
            ),
            onPressed: () {
              //TODO
            },
        ),
        FlatButton(
          child: ListTile(
            leading: Icon(Icons.description_rounded, color: Colors.black),
            title: Text('Orders', style: Theme.of(context).textTheme.headline6,),
            selected: false,
            selectedTileColor: Colors.grey.withOpacity(0.3),
          ),
          onPressed: () {
            //TODO
          },
        ),
        FlatButton(
          child: ListTile(
            leading: Icon(Icons.scatter_plot, color: Colors.black),
            title: Text('Analytics', style: Theme.of(context).textTheme.headline6,),
            selected: false,
            selectedTileColor: Colors.grey.withOpacity(0.3),
          ),
          onPressed: () {
            //TODO
          },
        ),
      ]
  );
}