program gwtBowling;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  uBowling in 'uBowling.pas';

var
  GameBowling: IGame;

begin
  try
    GameBowling := TGame.Create;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': Could not create GameBowling', E.Message);
  end;

    // ALE 20190805 throw some balls
    while NOT GameBowling.GameOver do
    begin
      GameBowling.Roll;
    end;

    // ALE 20190805 show some results
    WriteLn('Score: ' + GameBowling.TotalScore.ToString + ' Rolls: ' +
      GameBowling.TotalRolls.ToString);
    for var I := 1 to 10 do
    begin
      WriteLn('Frame: ' + GameBowling.ScoreByFrame[I].number.ToString +
        ' Rolls: ' + GameBowling.ScoreByFrame[I].rolls.ToString + ' Score: ' +
        GameBowling.ScoreByFrame[I].score.ToString);
      for var J := 1 to GameBowling.ScoreByFrame[I].rolls do
      begin
        WriteLn('  Roll ' + J.ToString + ' Pins Downed: ' +
          GameBowling.ScoreByFrame[I].Roll[J].ToString);
      end;

    end;
end.
