unit uBowling;

interface

uses SysUtils;

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
    roll: array [1 .. ROLLS_PER_FRAME_MAX] of Integer;
  end;

  TGameOfFrames = array [1 .. FRAMES_TOTAL] of TFrame;

  IGame = interface
    ['{A1E0B9A0-061A-40FF-8E57-0AD401FCAF8E}']
    function Start: Boolean;
    function Roll: Integer; Overload;
    function Roll(APinsDown: Integer): Integer; Overload;
    function ScoreByFrame: TGameOfFrames;
    function GetTotalScore: Integer;
    function GetTotalRolls: Integer;
    function GetCurrentFrame: Integer;
    function GetGameOver: Boolean;
    property CurrentFrame: Integer read GetCurrentFrame;
    property TotalScore: Integer read GetTotalScore;
    property TotalRolls: Integer read GetTotalRolls;
    property GameOver: Boolean read GetGameOver;
  end;

  TGame = class(TInterfacedObject, IGame)
  private
    FScore: Integer;
    FRolls: Integer; // ALE 20190805 Counting rolls for fun
    FFrame: Integer;
    FFrames: TGameOfFrames;
    FGameOver: Boolean;
    function GetCurrentFrame: Integer;
    function GetTotalScore: Integer;
    function GetTotalRolls: Integer;
    function GetGameOver: Boolean;
    function GetFramePinsDown: Integer; Overload;
    function GetFramePinsDown(const AFrame: Integer): Integer; Overload;
    function GetFrameStrikes(const AFrame: Integer): Integer;
    function GetFrameSpare(const AFrame: Integer): Boolean;
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

function TGame.GetFramePinsDown(const AFrame: Integer): Integer;
var
  I: Integer;
  PinsDown: Integer;
begin
  PinsDown := 0;
  for I := FFrames[AFrame].rolls downto 1 do
  begin
    Inc(PinsDown, FFrames[AFrame].roll[I]);
  end;
  result := PinsDown;
end;

function TGame.GetFramePinsDown: Integer;
begin
  result := GetFramePinsDown(FFrame);
end;

function TGame.GetGameOver: Boolean;
begin
  result := FGameOver;
end;

function TGame.GetTotalRolls: Integer;
begin
  result := FRolls;
end;

function TGame.GetTotalScore: Integer;
begin
  result := FScore;
end;

function TGame.GetFrameSpare(const AFrame: Integer): Boolean;
var
  Spare: Boolean;
  I: Integer;
begin
  Spare := False;
  if (AFrame < FRAMES_TOTAL) then
  begin
    // ALE 20190807 Pre-10th frame
    if (GetFrameStrikes(AFrame) = 0) AND (FFrames[AFrame].roll[1] + FFrames[AFrame].roll[2] = 10) then
    begin
      Spare := True;
    end;
  end
  else
  begin
    // ALE 20190807 10th frame
    if (GetFrameStrikes(AFrame) < 2) then
    begin
      // ALE 20190807 a spare can only happen in 10th frame if there are zero or one strikes
      if (FFrames[AFrame].roll[2] <> 10) then
      begin
        // ALE 20190807 can't have a spare if 2nd of 3 rolls is a strike
        if (FFrames[AFrame].roll[1] <> 10) AND (FFrames[AFrame].roll[1] + FFrames[AFrame].roll[2] = 10) then
        begin
          Spare := True;
        end
        else if (FFrames[AFrame].roll[3] <> 10) AND (FFrames[AFrame].roll[2] + FFrames[AFrame].roll[3] = 10) then
        begin
          Spare := True;
        end;
      end;
    end;
  end;
  result := Spare;
end;

function TGame.GetFrameStrikes(const AFrame: Integer): Integer;
var
  Strikes: Integer;
  I: Integer;
begin
  Strikes := 0;
  if (AFrame < FRAMES_TOTAL) then
  begin
    // ALE 20190807 Pre-10th frame
    if (FFrames[AFrame].roll[1] = 10) then
    begin
      Strikes := 1;
    end;
  end
  else
  begin
    // ALE 20190807 10th frame
    for I := 1  to ROLLS_PER_FRAME_MAX do
    begin
      if (FFrames[AFrame].roll[I] = 10) then
      begin
        Inc(Strikes);
      end;
    end;
  end;
  result := Strikes;
end;

function TGame.Roll: Integer;
begin
  result := -1;
  if (FFrame < FRAMES_TOTAL) then
  begin
    if FFrames[FFrame].rolls = 0 then
    begin
      result := roll(Random(11));
    end
    else
    begin
      result := roll(Random(11 - FFrames[FFrame].roll[1]));
    end;
  end
  else
  begin
    if FFrames[FFrame].rolls = 0 then
    begin
      result := roll(Random(11));
    end
    else if FFrames[FFrame].rolls = 1 then
    begin
      if FFrames[FFrame].roll[1] = 10 then
      begin
        result := roll(Random(11));
      end
      else
      begin
        result := roll(Random(11 - FFrames[FFrame].roll[1]));
      end;
    end
    else if FFrames[FFrame].rolls = 2 then
    begin
      if FFrames[FFrame].roll[2] = 10 then
      begin
        result := roll(Random(11));
      end
      else
      begin
        result := roll(Random(11 - FFrames[FFrame].roll[2]));
      end;
    end;
  end;
  if result = -1 then
  begin
    raise Exception.Create('Roll: Bowling alley is broken');
  end;
end;

function TGame.Roll(APinsDown: Integer): Integer;
var
  Rolls: Integer;
  I: Integer;
  MaxLookbackFrames: Integer;
begin
  if NOT FGameOver then
  begin
    //Inc(FScore, APinsDown);
    Inc(FRolls);
    Inc(FFrames[FFrame].rolls);
    Rolls := FFrames[FFrame].rolls;

    FFrames[FFrame].roll[Rolls] := APinsDown;

    // ALE 20190805 calculate score, use look-back to previous frames if needed
    FScore := 0; // ALE 20190806 indeterminate score
    if (FFrame < FRAMES_TOTAL) AND (GetFramePinsDown = 10) then
    begin
      FScore := -1; // ALE 20190806 Strike or Spare
    end
    else if (FFrame < FRAMES_TOTAL)
     AND (FFrames[FFrame].rolls < 3)
     AND (GetFramePinsDown >= 10) then
    begin
      FScore := -1; // ALE 20190806 Strike or Spare
    end
    else
    begin
      for I := FFrame downto 1 do
      begin
        if I > 2 then
        begin
          MaxLookbackFrames := 2;
        end
        else if I > 1 then
        begin
          MaxLookbackFrames := 1;
        end
        else
        begin
          MaxLookbackFrames := 0;
        end;


        if I < FRAMES_TOTAL then
        begin
          if GetFramePinsDown(I) = 10  then
          begin
            FScore := -1; // ALE 20190806 Strike or Spare
            break;
          end;
        end
        else
        begin
          // ALE 20190806 10th frame needs some finesse
          if (FFrames[FFrame].rolls < 3) AND (GetFramePinsDown >= 10) then
          begin
            FScore := -1; // ALE 20190806 Strike or Spare
            break;
          end;
        end;
      end;
    end;

    // ALE 20190805 10th frame crazy logic
    if (FFrame = FRAMES_TOTAL) then
    begin
      if Rolls = 2 then
      begin
        if FFrames[FFrame].roll[1] + FFrames[FFrame].roll[1] < 10 then
        begin
          FGameOver := True;
        end;
      end
      else if Rolls = 3 then
      begin
        FGameOver := True;
      end;
    end
    else
    begin
      // ALE 20190805 frame incrementing pre-10th frame
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
    end;

    result := APinsDown;
    { TODO -oUser -cShould only be able to roll as many pins as are still standing }
  end
  else
  begin
    raise Exception.Create('Game is already over man');
  end;
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
  FGameOver := False;
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
