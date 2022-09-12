import '../../boxes.dart';
import '../../models/job.dart';
import '../../models/trial_pit.dart';

//! Job functions
//add new Job
Future addJob(String jobNum, String jobTitle, List<TrialPit> trialPits) async {
  final Job job = Job()
    ..jobNumber = jobNum
    ..jobTitle = jobTitle
    ..trialPitList = trialPits;

  final box = Boxes.getJobs();
  box.add(job);
}

//edit existing Job
void edit(Job job, String jobNum, String jobTitle, List<TrialPit> trialPits) {
  job.jobNumber = jobNum;
  job.jobTitle = jobTitle;
  job.trialPitList = trialPits;
  job.save();
}

//delete existing Job
void deleteJob(Job job) {
  for (var e in job.trialPitList) {
    //TODO: make sure layers of the trial pit are also deleted
    //perhaps call deleteTrialPit() function instead of delete()
    e.delete();
  }
  job.delete();
}

//! Trial Pit functions
//TODO: implement Trial pit add/edit/delete

//! Layer functions
//TODO: implement Trial pit add/edit/delete
