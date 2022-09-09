class Session {
  List<Exercise> exercises;
  String presetName;

  //a session will be a collection of fixed exercises (1/many)
  Session(this.presetName, this.exercises);
}

class Exercise {
  //an exercise will be an exercise with varying set numbers
  String exName;
  int sets;
  //this is so that a preset session can summon as many cells as sets, each of
  //which able to hold different weight and reps
  Exercise(this.exName, this.sets);
}

class ExSet {
  //a set will be a single set of exercise with varying weights and reps
  String exName;
  int reps;
  int weight;

  //This will be filled in AFTER every rep, in a single summoned blank row
  ExSet(this.exName, this.reps, this.weight);
}
