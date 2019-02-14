import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trenstop/models/category.dart';

class ChannelManager {

  static ChannelManager _instance;

  static ChannelManager get instance {
    if (_instance == null) _instance = ChannelManager();
    return _instance;
  }

  final Firestore _store = Firestore.instance;

  static const String COLLECTION_TAG = "channels";
  static const String CATEGORY_TAG = "categories";

  CollectionReference get collection => _store.collection(COLLECTION_TAG);

  CollectionReference get categories => _store.collection(CATEGORY_TAG);


  // Queries
//  Query getUserChallenges(String userUid) => collection
//      .where("userUid", isEqualTo: userUid)
//      .orderBy("timestamp", descending: true);

  getCategories() async {
    QuerySnapshot querySnapshot = await categories.getDocuments();
    if(querySnapshot != null && querySnapshot.documents.length > 0) {
      List<Category> listCategories = querySnapshot.documents.map((snapshot) => Category.fromDocumentSnapshot(snapshot)).toList();
      return listCategories;
    } else
      return null;
  }

}