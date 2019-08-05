unit uBowling;

interface

type
  { ALE 20190805 What do we want to know about a Frame?
    1. 1st Roll result, 2. 2nd Roll result, 3. 3rd Roll result
    4. Frame # }
  IGame = interface ['{A1E0B9A0-061A-40FF-8E57-0AD401FCAF8E}']
    function Start: Boolean;
    function Roll: Integer; Overload;
    function Roll(APinsDown: Integer): Integer; Overload;
    function ScoreByFrame: Boolean;
    function GetTotalScore: Integer;
    property TotalScore: Integer read GetTotalScore;
  end;

  TGame =  class(TInterfacedObject, IGame)
  private
    FScore: Integer;
    function GetTotalScore: Integer;
  public
    constructor Create;
    function Start: Boolean;
    function Roll: Integer; Overload;
    function Roll(APinsDown: Integer): Integer; Overload;
    function ScoreByFrame: Boolean;
  end;
implementation

{ TGame }

constructor TGame.Create;
begin
  Randomize; // ALE 20190805 Set up random number generator
  FScore := 0;
end;

function TGame.GetTotalScore: Integer;
begin
  result := FScore;
end;

function TGame.Roll: Integer;
begin
  result := Roll(Random(10));
end;

function TGame.Roll(APinsDown: Integer): Integer;
begin
  Inc(FScore, APinsDown);
  result := FScore;
end;

function TGame.ScoreByFrame: Boolean;
begin
  result := False;
end;

function TGame.Start: Boolean;
begin
  result := False;
end;

end.
