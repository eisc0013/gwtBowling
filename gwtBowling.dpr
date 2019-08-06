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
    { TODO -oUser -cConsole Main : Insert code here }
    GameBowling := TGame.Create;

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

    {
      for var I := 0 to 22 do
      begin
      WriteLn(IntToStr(GameBowling.Roll) + ' ' + IntToStr(GameBowling.ScoreByFrame[GameBowling.CurrentFrame].rolls)
      + ' ' + IntToStr(GameBowling.ScoreByFrame[GameBowling.CurrentFrame].number)
      + ' ' + IntToStr(GameBowling.TotalScore)
      + ' ' + IntToStr(GameBowling.TotalRolls));
      end;
    }
  except
    on E: Exception do
      WriteLn(E.ClassName, ': Could not create GameBowling', E.Message);
  end;

end.
