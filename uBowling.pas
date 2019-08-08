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
    points: Integer;
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
    procedure IsTooManyPins(APinsDown: Integer);
    function GetLookForwardRolls(const I: Integer): Integer;
    procedure CalculateFramesPoints(APinsDown: Integer);
    procedure FrameIncrementer;
    function ScoreAtFrame(const AFrame: Integer): Integer;
    function CalculateScore: Integer;
  public
    constructor Create;
    function Start: Boolean;
    function Roll: Integer; Overload;
    function Roll(APinsDown: Integer): Integer; Overload;
    function ScoreByFrame: TGameOfFrames;
  end;

implementation

{ TGame }

function TGame.CalculateScore: Integer;
var
  I: Integer;
begin
  for I := 1 to FFrame do
  begin
    FFrames[I].score := ScoreAtFrame(I);
  end;
  result := FFrames[FFrame].score;
end;

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
begin
  if (NOT FGameOver) AND (APinsDown <> -1) then
  begin
    //Inc(FScore, APinsDown);
    Inc(FRolls);
    Inc(FFrames[FFrame].rolls);
    Rolls := FFrames[FFrame].rolls;
    FFrames[FFrame].roll[Rolls] := APinsDown;

    // ALE 20190808 error out if too many pins were knocked down
    IsTooManyPins(APinsDown);
    // ALE 20190908 re-calculate points associated to each frame
    CalculateFramesPoints(APinsDown);
    FScore := CalculateScore;
    // ALE 20190808 determine if rolls should result in moving to the next
    //  frame and also if the game is over
    FrameIncrementer;
  end
  else if ((APinsDown <> -1) AND (FGameOver = True)) then
  begin
    raise Exception.Create('Game is already over man');
  end;
  result := APinsDown;
end;

function TGame.ScoreByFrame: TGameOfFrames;
begin
  result := FFrames;
end;

function TGame.ScoreAtFrame(const AFrame: Integer): Integer;
var
  I: Integer;
  ScoreThruFrame: Integer;
begin
  ScoreThruFrame := 0;
  // ALE 20190807 Add up the scores of each frame
  if (FScore <> -1) then
  begin
    for I := 1 to AFrame do
    begin
      Inc(ScoreThruFrame, FFrames[I].points);
    end;
    result := ScoreThruFrame;
  end
  else
  begin
    result := -1;
  end;
end;

procedure TGame.FrameIncrementer;
var
  Rolls: Integer;
begin
  Rolls := FFrames[FFrame].rolls;

  // ALE 20190805 Is the game over?  10th frame crazy logic
  if (FFrame = FRAMES_TOTAL) then
  begin
    if Rolls = 2 then
    begin
      if FFrames[FFrame].roll[1] + FFrames[FFrame].roll[2] < 10 then
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
    if ((FFrames[FFrame].roll[1] = 10) and (FFrame < FRAMES_TOTAL)) then
    begin
      // ALE 20190805 got a strike, move us to next frame for all but 10th frame
      Inc(FFrame);
    end
    else if ((FFrames[FFrame].rolls = 2) and (FFrame < FRAMES_TOTAL)) then
    begin
      // ALE 20190805 rolled two balls, move us to next frame for all but 10th frame
      Inc(FFrame);
    end;
  end;
end;

procedure TGame.CalculateFramesPoints(APinsDown: Integer);
var
  MaxLookForwardRolls: Integer;
  FrameStrikes: Integer;
  I: Integer;
begin
  // ALE 20190805 calculate score, use look-forward to later frames if needed
  FScore := 0;
  if (FFrame < FRAMES_TOTAL) and (GetFramePinsDown = 10) then
  begin
    FScore := -1;
  end
  else // ALE 20190806 Strike or Spare
  if (FFrame = FRAMES_TOTAL) and (FFrames[FFrame].rolls < ROLLS_PER_FRAME_MAX) and (GetFramePinsDown >= 10) then
  begin
    FScore := -1;
  end
  else
  // ALE 20190806 Strike or Spare with one roll to go
  begin
    for I := FFrame downto 1 do
    begin
      MaxLookForwardRolls := GetLookForwardRolls(I);
      // ALE 20190807 get to actually scoring
      if I < FRAMES_TOTAL then
      begin
        FFrames[I].points := GetFramePinsDown(I);
        if (GetFrameStrikes(I) > 0) then
        begin
          // ALE 20190807 look forward two rolls
          if (MaxLookForwardRolls = 2) then
          begin
            Inc(FFrames[I].points, FFrames[I + 1].roll[1]);
            if (FFrames[I + 1].rolls > 1) then
            begin
              Inc(FFrames[I].points, FFrames[I + 1].roll[2]);
            end
            else
            begin
              Inc(FFrames[I].points, FFrames[I + 2].roll[1]);
            end;
          end
          else
          begin
            // ALE 20190807 need to roll more before score can be calculated
            FFrames[I].points := -1;
            FScore := -1;
            break;
          end;
        end
        else if (GetFrameSpare(I) = True) then
        begin
          // ALE 20190807 look forwad one roll
          if (MaxLookForwardRolls >= 1) then
          begin
            Inc(FFrames[I].points, FFrames[I + 1].roll[1]);
          end
          else
          begin
            // ALE 20190807 need to roll more before score can be calculated
            FFrames[I].points := -1;
            FScore := -1;
            break;
          end;
        end;
      end
      else
      begin
        // ALE 20190806 10th frame needs some finesse
        FFrames[I].points := 0;
        FrameStrikes := GetFrameStrikes(I);
        if (FFrames[I].rolls = 1) then
        begin
          if (FrameStrikes = 0) then
          begin
            Inc(FFrames[I].points, APinsDown);
          end
          else
          begin
            FFrames[I].points := -1;
            FScore := -1;
            break;
          end;
        end
        else if (FFrames[I].rolls = 2) then
        begin
          if (FrameStrikes = 0) then
          begin
            if (GetFrameSpare(I) = False) then
            begin
              Inc(FFrames[I].points, FFrames[I].roll[1] + APinsDown);
            end
            else
            begin
              // ALE 20190908 we have a spare
              FFrames[I].points := -1;
              FScore := -1;
              break;
            end;
          end
          else
          begin
            FFrames[I].points := -1;
            FScore := -1;
            break;
          end;
        end
        else
        begin
          // ALE 20190807 all three rolls in 10th frame
          if (FrameStrikes = 3) then
          begin
            Inc(FFrames[I].points, 30);
          end
          else if (FrameStrikes = 2) then
          begin
            // ALE 20190807 two strikes mean first two balls were strikes
            Inc(FFrames[I].points, 20 + APinsDown);
          end
          else if (FrameStrikes = 1) then
          begin
            // ALE 20190807 Could start with a Strike or a Spare
            if (FFrames[I].roll[1] = 10) then
            begin
              // ALE 20190807 First roll was a strike
              Inc(FFrames[I].points, 10 + FFrames[I].roll[2] + FFrames[I].roll[3]);
            end
            else
            begin
              // ALE 20190807 Third roll was a strike, First two were a spare
              Inc(FFrames[I].points, 20);
            end;
          end
          else
          begin
            // ALE 20190807 Frame starts with spare
            Inc(FFrames[I].points, 10 + APinsDown);
          end;
        end;
      end;
    end;
  end;
end;

function TGame.GetLookForwardRolls(const I: Integer): Integer;
var
  MaxLookForwardRolls: Integer;
begin
  // ALE 20190807 look-back logic is nonsensical, we look forward
  if (I = FFrame) then
  begin
    MaxLookForwardRolls := 0;
  end
  else if (I = FFrame - 1) then
  begin
    if (FFrames[I + 1].rolls = 1) then
    begin
      MaxLookForwardRolls := 1;
    end
    else
    begin
      MaxLookForwardRolls := 2;
    end;
  end
  else
  begin
    MaxLookForwardRolls := 2;
  end;
  result := MaxLookForwardRolls;
end;

procedure TGame.IsTooManyPins(APinsDown: Integer);
begin
  // Check for too many pins downed in frame
  if (APinsDown > 10) then
  begin
    raise Exception.Create('There are not that many pins man');
  end
  else if (FFrame < FRAMES_TOTAL) then
  begin
    if ((FFrames[FFrame].rolls = 2) and (FFrames[FFrame].roll[1] + FFrames[FFrame].roll[2] > 10)) then
    begin
      raise Exception.Create('There are not that many pins man');
    end;
  end
  else
  begin
    // ALE 20190807 10th frame
    if ((FFrames[FFrame].rolls >= 2) and (FFrames[FFrame].roll[1] < 10) and (FFrames[FFrame].roll[1] + FFrames[FFrame].roll[2] > 10)) then
    begin
      // ALE 20190807 may have a spare by 1st and 2nd roles
      raise Exception.Create('There are not that many pins man');
    end
    else if ((FFrames[FFrame].rolls = 3) and (FFrames[FFrame].roll[1] = 10) and (FFrames[FFrame].roll[2] < 10) and (FFrames[FFrame].roll[2] + FFrames[FFrame].roll[3] > 10)) then
    begin
      // ALE 20190807 first roll strike, second roll not strike
      raise Exception.Create('There are not that many pins man');
    end;
  end;
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
    FFrames[I].points := -1;
    FFrames[I].score := -1;
  end;

  result := True;
end;

end.
