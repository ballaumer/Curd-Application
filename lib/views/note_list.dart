import 'package:flutter/material.dart';
import 'package:fluttercrud/Models/apiResponse.dart';
import 'package:get_it/get_it.dart';
import 'package:fluttercrud/Models/note_for_listing.dart';
import 'package:fluttercrud/controller/notice_service.dart';

import 'note_delete.dart';
import 'note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoticeServices get service => GetIt.I<NoticeServices>();
  ApiResponse<List<NoteForListing>> _apiResponse;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  bool _isLoading = false ;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNoticeList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NoteModify()))
              .then((_) => _fetchNotes());
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (_apiResponse.error) {
            return Center(
              child: Text(_apiResponse.errorMessage),
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Colors.green),
            itemCount: _apiResponse.data.length,
              itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(_apiResponse.data[index].noteID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  _apiResponse.data.removeAt(index).noteID;
                },
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => NoteDelete(),
                  );
                  if(result){
                    final deleteResult = await service.deleteNote(_apiResponse.data[index].noteID);
                    var message;
                    if(deleteResult != null && deleteResult.data == true){
                      message = 'The note was deleted successfully';
                    }
                    else{
                      message = deleteResult?.errorMessage ?? "An error occured";
                    }
                    showDialog(context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Done"),
                          content: Text(message),
                          actions: <Widget>[
                            FlatButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, child: Text("OK"))
                          ],
                        ));

                    return deleteResult?.data ?? false;
                  }

                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    "${_apiResponse.data[index].noteTitle}",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text(
                      "Last edited ${formatDateTime(_apiResponse.data[index].createDateTime)}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoteModify(
                                  noteID: _apiResponse.data[index].noteID,
                                ))).then((_) => _fetchNotes());
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
