enum DeliverableAction {
  deliverableActionMeetAtDoor,
  deliverableActionLeaveAtDoor,
}

extension DeliverableActionExtension on DeliverableAction {
  String get name {
    switch (this) {
      case DeliverableAction.deliverableActionMeetAtDoor:
        return 'deliverable_action_meet_at_door';
      case DeliverableAction.deliverableActionLeaveAtDoor:
        return 'deliverable_action_leave_at_door';
      default:
        return 'deliverable_action_meet_at_door';
    }
  }
}

extension ParseDeliverableAction on String {
  DeliverableAction get toDeliverableAction {
    switch (this) {
      case 'deliverable_action_meet_at_door':
        return DeliverableAction.deliverableActionMeetAtDoor;
      case 'deliverable_action_leave_at_door':
        return DeliverableAction.deliverableActionLeaveAtDoor;
      default:
        return DeliverableAction.deliverableActionMeetAtDoor;
    }
  }
}
