import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum SubscriptionStatus { subscribed, notSubscribed }

class SubscribeCubit extends Cubit<SubscriptionStatus> {
  final String userId;
  final String creatorId;

  SubscribeCubit(this.userId, this.creatorId) : super(SubscriptionStatus.notSubscribed) {
    _fetchInitialStatus();
  }

  void _fetchInitialStatus() async {
    bool isSubscribed = await _isSubscribed();
    emit(isSubscribed ? SubscriptionStatus.subscribed : SubscriptionStatus.notSubscribed);
  }

  Future<bool> _isSubscribed() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    List<dynamic>? subscribes = userDoc['subscribes'];
    return subscribes != null && subscribes.contains(creatorId);
  }

  void subscribe() async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'subscribes': FieldValue.arrayUnion([creatorId])
    });
    emit(SubscriptionStatus.subscribed);
  }

  void unsubscribe() async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'subscribes': FieldValue.arrayRemove([creatorId])
    });
    emit(SubscriptionStatus.notSubscribed);
  }
}
