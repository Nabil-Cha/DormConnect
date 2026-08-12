import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hci_mi5y_dormconnect/models/activity/activity.dart';

enum ActivityFilter {
  all,
  joined,
  notJoined,
}

class ActivityService {
  static final supabase = Supabase.instance.client;

  static Future<void> addActivity({
    required String title,
    required String description,
    required DateTime startDate,
    required int maxParticipants,
    required String location,
    required String community,
    int? communityId,
    String? image,
    String category = 'General',
  }) async {
    try {
      final activityData = {
        'title': title,
        'description': description,
        'start_date': startDate.toIso8601String(),
        'end_date': startDate.add(const Duration(hours: 2)).toIso8601String(),
        'max_participants': maxParticipants,
        'location': location,
        'image': image ?? 'https://mldhavqvdntcrfowiqjk.supabase.co/storage/v1/object/public/assets/communities_images/karlshof.jpg',
        'created_at': DateTime.now().toIso8601String(),
        'participants': [],
        'community': community,
        'category': category,
      };

      if (communityId != null) {
        activityData['community_id'] = communityId;
      }

      await supabase.from('activities').insert(activityData);
    } catch (e) {
      throw Exception('Fehler beim Hinzufügen der Aktivität: $e');
    }
  }

  static Future<List<Activity>> getActivitiesByCommunity(int communityId) async {
    try {
      final response = await supabase
          .from('activities')
          .select()
          .eq('community_id', communityId)
          .eq('is_active', true)
          .order('start_date');

      return (response as List)
          .map((data) => Activity.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Fehler beim Laden der Aktivitäten: $e');
    }
  }

  static Future<List<Activity>> getActivitiesByCommunityFiltered({
    required int communityId,
    String? participantId,
    ActivityFilter filter = ActivityFilter.all,
  }) async {
    try {
      final response = await supabase
          .from('activities')
          .select()
          .eq('community_id', communityId)
          .eq('is_active', true)
          .order('start_date');

      final activities = (response as List)
          .map((data) => Activity.fromMap(data))
          .toList();

      if (participantId == null) {
        return activities;
      }

      switch (filter) {
        case ActivityFilter.joined:
          return activities.where((a) => a.participants.contains(participantId)).toList();
        case ActivityFilter.notJoined:
          return activities.where((a) => !a.participants.contains(participantId)).toList();
        case ActivityFilter.all:
        default:
          return activities;
      }
    } catch (e) {
      throw Exception('Fehler beim Laden der Aktivitäten: $e');
    }
  }

  static Future<Activity?> getActivityById(int id) async {
    try {
      final response = await supabase
          .from('activities')
          .select()
          .eq('id', id)
          .single();

      return Activity.fromMap(response);
    } catch (e) {
      throw Exception('Fehler beim Laden der Aktivität: $e');
    }
  }

  static Future<void> updateActivity(Activity activity) async {
    try {
      await supabase
          .from('activities')
          .update(activity.toMap())
          .eq('id', activity.id);
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren der Aktivität: $e');
    }
  }

  static Future<void> deleteActivity(int id) async {
    try {
      await supabase
          .from('activities')
          .update({'is_active': false})
          .eq('id', id);
    } catch (e) {
      throw Exception('Fehler beim Löschen der Aktivität: $e');
    }
  }

  static Future<void> joinActivity(int activityId, String participantId) async {
    try {
      final activity = await getActivityById(activityId);
      if (activity == null) {
        throw Exception('Aktivität nicht gefunden');
      }

      if (activity.participants.contains(participantId)) {
        return;
      }

      if (activity.isFull) {
        throw Exception('Aktivität ist bereits voll');
      }

      final updatedActivity = activity.addParticipant(participantId);
      await updateActivity(updatedActivity);
    } catch (e) {
      throw Exception('Fehler beim Beitreten zur Aktivität: $e');
    }
  }

  static Future<void> leaveActivity(int activityId, String participantId) async {
    try {
      final activity = await getActivityById(activityId);
      if (activity == null) {
        throw Exception('Aktivität nicht gefunden');
      }

      final updatedActivity = activity.removeParticipant(participantId);
      await updateActivity(updatedActivity);
    } catch (e) {
      throw Exception('Fehler beim Verlassen der Aktivität: $e');
    }
  }
}
