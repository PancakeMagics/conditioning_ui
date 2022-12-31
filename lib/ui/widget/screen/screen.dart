part of widget;

enum Screen with ScreenData {

  ///
  ///
  /// stateless screens
  ///
  ///

  ///
  /// - login: for user to login
  /// - treasure: for user to see her/his profile, history, all the [Script], [Event], reference some game's player profile.
  /// - map: for user to setting application, manage preferences and all the other page and screens.
  login,
  treasure,
  map,

  /// bottom line items:
  /// - chatroom: for a person to live with the people she/he familiar with.
  /// - org: for a person to access the information of organization she/he stays, including government.
  /// - documention: for a person to communicate with org member easily.
  chatroom,
  org,
  documention,

  /// center line items:
  /// - studyGram: mainly for [ScriptAbility], reference "Coursera", or some popular game
  /// - medium: mainly for [ScripConscious], reference "Twitter", "Medium", "Quara", "Stack Overflow"
  /// - myWay: mainly for [ScriptFeel], reference 'explore' part of "Facebook", "Instagram"
  studyGram,
  medium,
  myWay,

  /// top line items:
  /// - meetup: mainly for [EventAbility], reference "Meet up"
  /// - schedule: mainly for [EventConscious], reference "TimeTree"
  /// - now: mainly for [EventFeel], reference "power point", "Jamboard", "Kahoot", "mentimater"
  meetup,
  schedule,
  now,


  ///
  ///
  /// stateful screens
  ///
  ///

  editProfile,
  editScript,
  editEvent,
  editCalendar,
  lobbyStick,
  lobbyConditioning;
}