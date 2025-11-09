abstract class SensorWebsocketRepository {
  void init(String serialNumber);
  void reconnect(String serialNumber);
  void dispose();
}
