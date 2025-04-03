/*
Stats to include:
Current coin amount
Total coins earned
Total coins spent
Total items bought
Current content streak
Longest content streak
Projects created
Projects completed
Content created
Content completed

optional? might add functionality
Coin earning multiplier
User level
Experience earned
Experience for next level
*/

import 'dart:math';

class Stats{
  int coins = 0;
  int coinsEarned = 0;
  int coinsSpent = 0;
  int itemsBought = 0;
  int contentStreak = 0;
  int longestStreak = 0;
  int projectsCreated = 0;
  int projectsCompleted = 0;
  int projectsFailed = 0;
  int contentCreated = 0;
  int contentCompleted = 0;
  int contentFailed = 0;
  double coinMultiplier = 0.0;

  Stats(int coinsIn, int coinsEarnedIn, int coinsSpentIn,
      int itemsBoughtIn, int contentStreakIn, int longestStreakIn,
      int projectsCreatedIn, int projectsCompletedIn, int projectsFailedIn,
      int contentCreatedIn, int contentCompletedIn, int contentFailedIn){
    coins = coinsIn;
    coinsEarned = coinsEarnedIn;
    coinsSpent = coinsSpentIn;
    itemsBought = itemsBoughtIn;
    contentStreak = contentStreakIn;
    longestStreak = longestStreakIn;
    projectsCreated = projectsCreatedIn;
    projectsCompleted = projectsCompletedIn;
    projectsFailed = projectsFailedIn;
    contentCreated = contentCreatedIn;
    contentCompleted = contentCompletedIn;
    contentFailed = contentFailedIn;
    updateMultiplier();
  }

  void updateMultiplier(){
    //increase mult by 0.1 per 3, max of 3
    double mult = (0.1 * contentStreak) + 1;
    coinMultiplier = min(mult, 3.0);
  }

  String toCSV(){
    String out = "";
    out += ("$coins,");
    out += ("$coinsEarned,");
    out += ("$coinsSpent,");
    out += ("$itemsBought,");
    out += ("$contentStreak,");
    out += ("$longestStreak,");
    out += ("$projectsCreated,");
    out += ("$projectsCompleted,");
    out += ("$projectsFailed,");
    out += ("$contentCreated,");
    out += ("$contentCompleted,");
    out += ("$contentFailed,");
    return out;
  }
}