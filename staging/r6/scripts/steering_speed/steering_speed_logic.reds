public class SteeringSpeedLogic {
    public static func SteeringMultFromIdx(idx: Int32) -> Float {
        if idx == 0 { return 0.5; }
        if idx == 1 { return 1.0; }
        if idx == 2 { return 1.5; }
        if idx == 3 { return 3.0; }
        if idx == 4 { return 10.0; }
        if idx == 5 { return 50.0; }
        if idx == 6 { return 100.0; }
        if idx == 7 { return 500.0; }
        if idx == 8 { return 1000.0; }
        return 1.0;
    }

    public static func ApplyMultipliers(turnMult: Float, recenterMult: Float) -> Void {
        let records = TweakDBInterface.GetRecords(n"gamedataVehicleDriveModelData_Record");
        SteeringSpeedLogic.ProcessRecords(records, turnMult, recenterMult);
        
        let bikeRecords = TweakDBInterface.GetRecords(n"gamedataBikeDriveModelData_Record");
        SteeringSpeedLogic.ProcessRecords(bikeRecords, turnMult, recenterMult);
    }

    private static func ProcessRecords(records: array<ref<TweakDBRecord>>, turnMult: Float, recenterMult: Float) -> Void {
        let i = 0;
        while i < ArraySize(records) {
            let driveModel = records[i] as VehicleDriveModelData_Record;
            if IsDefined(driveModel) {
                let id = driveModel.GetID();
                
                let origAdd = TweakDBInterface.GetFloat(id + t".wheelTurnMaxAddPerSecond_orig", -9999.0);
                if origAdd == -9999.0 {
                    origAdd = driveModel.WheelTurnMaxAddPerSecond();
                    TweakDBManager.SetFlat(id + t".wheelTurnMaxAddPerSecond_orig", origAdd);
                }

                let origSub = TweakDBInterface.GetFloat(id + t".wheelTurnMaxSubPerSecond_orig", -9999.0);
                if origSub == -9999.0 {
                    origSub = driveModel.WheelTurnMaxSubPerSecond();
                    TweakDBManager.SetFlat(id + t".wheelTurnMaxSubPerSecond_orig", origSub);
                }
                
                if origAdd != 0.0 || origSub != 0.0 {
                    let newAdd = origAdd * turnMult;
                    let newSub = origSub * recenterMult;
                    
                    TweakDBManager.SetFlat(id + t".wheelTurnMaxAddPerSecond", newAdd);
                    TweakDBManager.SetFlat(id + t".wheelTurnMaxSubPerSecond", newSub);
                    TweakDBManager.UpdateRecord(id);
                }
            }
            i += 1;
        }
    }
}
