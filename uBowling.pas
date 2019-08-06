unit uBowling;

interface

  const
    FRAMES_TOTAL = 10;
    ROLLS_PER_FRAME_MAX = 3;

  type
  { ALE 20190805 What do we want to know about a Frame?
    1. 1st Roll result, 2. 2nd Roll result, 3. 3rd Roll result
    4. Frame # }
  TFrame = record
    number: Integer;
    rolls: Integer;
    score: Integer;
    roll: array[1..ROLLS_PER_FRAME_MAX] of Integer;
  end;
  TGameOfFrames = array [1..FRAMES_TOTAL] of TFrame;

  IGame = interface ['{A1E0B9A0-061A-40FF-8E57-0AD401FCAF8E}']
    function Start: Boolean;
    function Roll: Integer; Overload;
    function Roll(APinsDown: Integer): Integer; Overload;
    function ScoreByFrame: TGameOfFrames;
    function GetTotalScore: Integer;
    function GetTotalRolls: Integer;
    function GetCurrentFrame: Integer;
    property CurrentFrame: Integer read GetCurrentFrame;
    property TotalScore: Integer read GetTotalScore;
    property TotalRolls: Integer read GetTotalRolls;
  end;

  TGame =  class(TInterfacedObject, IGame)
  private
    FScore: Integer;
    FRolls: Integer; // ALE 20190805 Counting rolls for fun
    FFrame: Integer;
    FFrames: TGameOfFrames;
    function GetCurrentFrame: Integer;
    function GetTotalScore: Integer;
    function GetTotalRolls: Integer;
  public
    constructor Create;
    function Start: Boolean;
    function Roll: Integer; Overload;
    function Roll(APinsDown: Integer): Integer; Overload;
    function ScoreByFrame: TGameOfFrames;
  end;
implementation

{ TGame }

constructor TGame.Create;
begin
  Randomize; // ALE 20190805 Set up random number generator
  FScore := -1;
  FRolls := -1;
  FFrame := -1;
  Start; // ALE 20190805 Do we really want to do this or just initialize in Create?
end;

function TGame.GetCurrentFrame: Integer;
begin
  result := FFrame;
end;

function TGame.GetTotalRolls: Integer;
begin
  result := FRolls;
end;

function TGame.GetTotalScore: Integer;
begin
  result := FScore;
end;

function TGame.Roll: Integer;
begin
  if (FFrame < FRAMES_TOTAL) then
  begin
    if FFrames[FFrame].rolls = 0 then
    begin
      result := Roll(Random(11));
    end
    else
    begin
      result := Roll(Random(11 - FFrames[FFrame].roll[1]));
    end;
  end
  else
  begin
    { TODO -oUser -cShould only be able to roll as many pins as are still standing }
    result := Roll(Random(11));
  end;


end;

function TGame.Roll(APinsDown: Integer): Integer;
var
  lRolls: Integer;
begin
  Inc(FScore, APinsDown);
  Inc(FRolls);
  Inc(FFrames[FFrame].rolls);
  lRolls := FFrames[FFrame].rolls;

  FFrames[FFrame].roll[lRolls] := APinsDown;

  if ((FFrames[FFrame].roll[1] = 10) AND (FFrame < FRAMES_TOTAL)) then
  begin
    // ALE 20190805 got a strike, move us to next frame for all but 10th frame
    Inc(FFrame);
  end
  else if ((FFrames[FFrame].rolls = 2) AND (FFrame < FRAMES_TOTAL)) then
  begin
    // ALE 20190805 rolled two balls, move us to next frame for all but 10th frame
    Inc(FFrame);
  end;

  // ALE 20190805 calculate score, use look-back to previous frames if needed

  result := APinsDown;
  { TODO -oUser -cShould only be able to roll as many pins as are still standing }
end;

function TGame.ScoreByFrame: TGameOfFrames;
begin
  result := FFrames;
end;

function TGame.Start: Boolean;
var
  I: Integer;
  J: Integer;
begin
  FScore := 0;
  FRolls := 0;
  FFrame := 1;

  // ALE 20190801 consider moving Frame clearer to its own function or class
  for I := 1 to FRAMES_TOTAL do
  begin
    FFrames[I].number := I;
    FFrames[I].rolls := 0;
    for J := 1 to ROLLS_PER_FRAME_MAX do
    begin
      FFrames[I].roll[J] := -1;
    end;
    FFrames[I].score := -1;
  end;

  result := True;
end;

end.