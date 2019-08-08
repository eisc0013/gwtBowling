unit uExampleHelpers;

interface
  uses SysUtils, uBowling;

  function Menu: Integer;
  procedure BowlingResultsPrint(AGameBowling: IGame);
  procedure BowlingAuto(AGameBowling: IGame);
  procedure BowlingManual(AGameBowling: IGame);
  function FormatScore(const AScore: Integer): String;

implementation

function Menu: Integer;
var
  Cmd: String;
begin
  result := -1;
  WriteLn(Output, '');
  WriteLn(Output, 'Menu:');
  WriteLn(Output, ' 1. Auto-roll entire game');
  WriteLn(Output, ' 2. Enter pins knocked down by each roll');
  WriteLn(Output, ' 3. Exit');
  Write(Output, 'Type number of your choice and press <Enter> ');
  ReadLn(Input, Cmd);
  WriteLn(Output, '');
  TryStrToInt(Cmd, result);
end;

procedure BowlingResultsPrint(AGameBowling: IGame);
begin
  // ALE 20190805 show some results
  WriteLn('Score: ' + AGameBowling.TotalScore.ToString + ' Rolls: ' +
    AGameBowling.TotalRolls.ToString);
  for var I := 1 to 10 do
  begin
    WriteLn('Frame: ' + AGameBowling.ScoreByFrame[I].number.ToString +
      ' Rolls: ' + AGameBowling.ScoreByFrame[I].rolls.ToString + ' Points: ' +
      FormatScore(AGameBowling.ScoreByFrame[I].points) + ' Score: ' +
      FormatScore(AGameBowling.ScoreByFrame[I].score));
    for var J := 1 to AGameBowling.ScoreByFrame[I].rolls do
    begin
      WriteLn('  Roll ' + J.ToString + ' Pins Downed: ' +
        AGameBowling.ScoreByFrame[I].Roll[J].ToString);
    end;
  end;
end;

procedure BowlingAuto(AGameBowling: IGame);
begin
  AGameBowling.Start;
  // ALE 20190805 throw some balls
  while NOT AGameBowling.GameOver do
  begin
    AGameBowling.Roll;
  end;
end;

procedure BowlingManual(AGameBowling: IGame);
var
  PinsInput: String;
  Pins: Integer;
begin
  AGameBowling.Start;
  // ALE 20190805 throw some balls
  while NOT AGameBowling.GameOver do
  begin
    Write('Please type the number of pins knocked down with the roll then press <Enter> ');
    ReadLn(PinsInput);
    if (TryStrToInt(PinsInput, Pins) = True) then
    begin
      AGameBowling.Roll(Pins);
      WriteLn('Current Frame: ' + AGameBowling.CurrentFrame.ToString + ' Total Score: ' + FormatScore(AGameBowling.TotalScore));
    end;
  end;
end;

function FormatScore(const AScore: Integer): String;
begin
  if (AScore = -1) then
  begin
    result := 'Indeterminate';
  end
  else
  begin
    result := AScore.ToString;
  end;
end;
end.
