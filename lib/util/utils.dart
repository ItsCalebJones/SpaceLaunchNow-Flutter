
class Utils {

  static String getStatus(int status){
    String missionStatus = "Unknown";
    switch(status) {

      case 1: {
        //statements;
        missionStatus = "Launch is GO";
      }
      break;

      case 2: {
        //statements;
        missionStatus = "Launch is NO-GO";
      }
      break;

      case 3: {
        //statements;
        missionStatus = "Launch was Successful";
      }
      break;

      case 4: {
        //statements;
        missionStatus = "Launch Failure";
      }
      break;

      case 5: {
        //statements;
        missionStatus = "Unplanned Hold";
      }
      break;

      case 6: {
        //statements;
        missionStatus = "In Flight";
      }
      break;

      case 7: {
        //statements;
        missionStatus = "Partial Failure";
      }
      break;

      default: {
        //statements;
        missionStatus = "Unknown";
      }
      break;
    }

    return missionStatus;
  }
}