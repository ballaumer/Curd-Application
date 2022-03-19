import 'package:flutter/material.dart';
import 'package:fluttercrud/Models/createNote.dart';
import 'package:fluttercrud/Models/note.dart';
import 'package:fluttercrud/controller/notice_service.dart';
import 'package:get_it/get_it.dart';


class NoteModify extends StatefulWidget {

  final String noteID;
    NoteModify({this.noteID});

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID  != null;

  NoticeServices get noteService => GetIt.I<NoticeServices>();

  bool _isLoading = false;

  String errorMessage;

  Note note;


  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();

  @override
  void initState() {
    if(isEditing){
      setState(() {
        _isLoading = true;
      });
     noteService.getNote(widget.noteID).
     then((response) {
     setState(() {
       _isLoading = false;
     });

     if(response.error){
       errorMessage = response.errorMessage ?? "An error Occurred";
     }
     note = response.data;
     _titleEditingController.text = note.noteTitle;
     _contentEditingController.text = note.noteContent;

     } );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Note" : " Create Note"),),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:  _isLoading ? const Center(child: CircularProgressIndicator()) :Column(
            children: <Widget>[
              TextField(
                controller:  _titleEditingController,
                decoration: const InputDecoration(
                  hintText: "NoteTitle"
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller:  _contentEditingController,
                decoration: const InputDecoration(
                  hintText: "Note Content"
                ),
              ),
             const SizedBox(
               height: 20,
             ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async{
                      if(isEditing){
                        setState(() {
                          _isLoading = true;
                        });
                        final update = NoteInsert(
                          noteTitle: _titleEditingController.text,
                          noteContent: _contentEditingController.text
                        );
                        final result =  await noteService.updateNote(update, widget.noteID);
                        setState(() {
                          _isLoading = false;
                        });
                        const title ="Done";
                        final text = result.error ? (result.errorMessage ?? "An error occurred") :
                        "Successfully updated"  ;

                        showDialog(context: context,
                            builder: (_) => AlertDialog(
                              title: const Text(title),
                              content: Text(text),
                              actions: <Widget> [
                                ElevatedButton(
                                  child: const Text("OK"),
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            )).then((value) {
                             if(result.data){
                               Navigator.of(context).pop();
                             }
                        });
                      }

                      else {
                      setState(() {
                        _isLoading = true;
                      });
                      final insert = NoteInsert(
                        noteTitle:  _titleEditingController.text,
                        noteContent: _contentEditingController.text
                      );
                      final result = await noteService.createNote(insert);
                       setState(() {
                         _isLoading = false;
                       });

                       const title ="Done";
                       final text = result.error ? ( result. errorMessage ?? "An error occurred") :
                       "Your note was created";

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text(title),
                            content: Text(text),
                            actions: <Widget> [
                              ElevatedButton(
                                child: const Text("OK"),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          )
                      ).then((data) {
                       if(result.data){
                         Navigator.of(context).pop();
                       }
                      });

                      }
                    },
                    child: Text(isEditing ? "Update" :"Submit")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
