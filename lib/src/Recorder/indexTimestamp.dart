import 'dart:core';

// IndexTimestamp should not be accessed directly, but only through IndexTimeLine class
class IndexTimestamp {
  final DateTime time;
  final int index;
  IndexTimestamp? next;
  IndexTimestamp? previous;

  IndexTimestamp(
      {required this.time, required this.index, this.next, this.previous});

  void setPrevious(IndexTimestamp? previous) {
    this.previous = previous;
  }

  void setNext(IndexTimestamp? next) {
    this.next = next;
  }

  IndexTimestamp? getPreviousTimestamp() {
    return previous;
  }

  IndexTimestamp? getNextTimestamp() {
    return next;
  }

  // operations
  Duration operator -(IndexTimestamp other) {
    return time.difference(other.time);
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'index': index,
        'next': next == null ? 'null' : next!.toJson(),
      };
}

class IndexTimeLine {
  IndexTimestamp? first;
  IndexTimestamp? last;
  int? _length;
  Duration timeout;

  IndexTimeLine({this.first, this.timeout = const Duration(seconds: 10)}) {
    if (this.first == null) {
      first = null;
      last = null;
      _length = 0;
    } else {
      last = first;
      _length = 1;
    }
  }

  // Creates new IndexTimestamp and adds to the index timeline
  void createThenAdd(index) {
    IndexTimestamp newStamp = createTimestamp(index);

    // checks timeout
    if (checkTimeout(last, newStamp)) {
      addIndexTimestamp(newStamp);
    }
  }

  // Adds the given timestamp to the timeline
  void addIndexTimestamp(IndexTimestamp stamp) {
    // safety check for incomming stamp:
    // incomming stamp should have null parent and child
    if (stamp.getPreviousTimestamp() != null) {
      return;
    }

    if (first == null && last == null) {
      first = stamp;
      last = stamp;
      _length = 1;
    } else {
      last!.setNext(stamp);
      stamp.setPrevious(last);
      last = stamp;
      _length = _length! + 1;
    }
  }

  // Creates new IndexTimestamp and returns the stamp
  IndexTimestamp createTimestamp(int index) {
    IndexTimestamp newStamp =
        IndexTimestamp(time: DateTime.now(), index: index);
    newStamp.setPrevious(null);
    newStamp.setNext(null);
    return newStamp;
  }

  // Iterates through all timestamps from the first
  void iterateFromStart() {
    return;
  }

  // Gets the IndexTimestamp at the index position
  // If out of bound, return null
  IndexTimestamp? getIndex(int index) {
    if (index >= getLength() || index < 0) {
      // out of bound
      return null;
    }

    if (index == 0) {
      return first;
    }

    if (index == getLength() - 1) {
      return last;
    }

    IndexTimestamp tempStamp = first!;

    for (int i = 0; i <= getLength(); i++) {
      if (i == index) {
        return tempStamp;
      }
      tempStamp = tempStamp.getNextTimestamp()!;
    }
    return null;
  }

  int getLength() {
    return _length!;
  }

  // Swaps a and b from their position then return true
  // If out of bound, return false
  bool swap({required IndexTimestamp a, required IndexTimestamp b}) {
    return false;
  }

  Duration getDuration() {
    if (getLength() == 0) {
      return const Duration(seconds: 0);
    }

    return last! - first!;
  }

  bool checkTimeout(IndexTimestamp? last, IndexTimestamp next) {
    if (last == null) {
      // returns true for the first timestamp of the timeline
      return true;
    }

    if (next - last <= timeout) {
      return true;
    }

    return false;
  }

  Map<String, dynamic> toJson() => {
        // first is detined by the timeline json, which is recursively defined:
        // {
        //    time: 2023-04-26 11:11:28.953328,
        //    index: 0,
        //    next: {
        //              time: 2023-04-26 11:11:28.979564,
        //              index: 0,
        //              next: { ...
        //            }
        // }
        'first': first == null ? 'null' : first!.toJson(),
        'length': _length,
      };
}
