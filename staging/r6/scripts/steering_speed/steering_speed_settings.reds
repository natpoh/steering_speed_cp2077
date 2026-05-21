public class SteeringSpeedSettings extends IScriptable {

  @runtimeProperty("ModSettings.mod", "Steering Speed")
  @runtimeProperty("ModSettings.category", "Speed Config")
  @runtimeProperty("ModSettings.category.order", "100")
  @runtimeProperty("ModSettings.displayName", "Steering turn speed")
  @runtimeProperty("ModSettings.description", "How fast in-game wheels turn when you steer. 0=x0.5  1=STOCK  2=x1.5  3=x3  4=x10  5=x50  6=x100  7=x500  8=x1000. Changes apply when you mount a vehicle.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "8")
  @runtimeProperty("ModSettings.step", "1")
  let steeringTurnSpeedIdx: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Steering Speed")
  @runtimeProperty("ModSettings.category", "Speed Config")
  @runtimeProperty("ModSettings.category.order", "100")
  @runtimeProperty("ModSettings.displayName", "Steering re-center speed")
  @runtimeProperty("ModSettings.description", "How fast in-game wheels snap back to center. 0=x0.5  1=STOCK  2=x1.5  3=x3  4=x10  5=x50  6=x100  7=x500  8=x1000. Changes apply when you mount a vehicle.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "8")
  @runtimeProperty("ModSettings.step", "1")
  let steeringRecenterSpeedIdx: Int32 = 1;

  public func OnModSettingsChange() -> Void {
    this.Push();
  }

  public func Push() -> Void {
    let turnMult = SteeringSpeedLogic.SteeringMultFromIdx(this.steeringTurnSpeedIdx);
    let recenterMult = SteeringSpeedLogic.SteeringMultFromIdx(this.steeringRecenterSpeedIdx);
    SteeringSpeedLogic.ApplyMultipliers(turnMult, recenterMult);
  }
}

@addField(PlayerPuppet)
public let m_steering_speedSettings: ref<SteeringSpeedSettings>;

@wrapMethod(PlayerPuppet)
protected cb func OnGameAttached() -> Bool {
  let result: Bool = wrappedMethod();
  if !IsDefined(this.m_steering_speedSettings) {
    this.m_steering_speedSettings = new SteeringSpeedSettings();
    ModSettings.RegisterListenerToClass(this.m_steering_speedSettings);
    this.m_steering_speedSettings.Push();
  }
  return result;
}
