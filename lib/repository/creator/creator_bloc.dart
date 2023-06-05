import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatorsState {
  final List<QueryDocumentSnapshot> creators;

  CreatorsState(this.creators);
}

class CreatorsCubit extends Cubit<CreatorsState> {
  final String currentUserUid;

  CreatorsCubit(this.currentUserUid) : super(CreatorsState([])) {
    _fetchCreators();
  }

  void _fetchCreators() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('creators').get();
    List<QueryDocumentSnapshot> creatorDocs = snapshot.docs.where((doc) => doc.id != currentUserUid).toList();
    emit(CreatorsState(creatorDocs));
  }
}
