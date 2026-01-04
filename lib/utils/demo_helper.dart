/// Helper pour détecter si on est en mode démo
class DemoHelper {
  static bool isDemoMode = false;
  
  /// Active le mode démo
  static void enableDemoMode() {
    isDemoMode = true;
  }
  
  /// Désactive le mode démo
  static void disableDemoMode() {
    isDemoMode = false;
  }
}









