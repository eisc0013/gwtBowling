unit uTests;

interface
uses
  DUnitX.TestFramework, uBowling;

type

  [TestFixture]
  TTestGame = class(TObject)
  strict private
    GameBowling: IGame;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure BowlingGameInstantiate;
    [Test]
    procedure BowlingGameInitialState;
    [Test]
    [TestCase('Five', '5,5')]
    [TestCase('GutterBall', '0,0')]
    [TestCase('Strike', '10,10')]
    procedure BowlingGameRollFirst(const APinsDown: Integer; const OResult: Integer);
    [Test]
    [TestCase('Spare', '5,5,10')]
    procedure BowlingGameRollTwo(const APinsDown1: Integer; const APinsDown2: Integer; const OResult: Integer);
    [Test]
    [TestCase('Five', '5,5')]
    procedure BowlingGameRollCount(const ARolls: Integer; const OResult: Integer);
    [Test]
    procedure BowlingGamePerfect;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TTestGame.BowlingGameInitialState;
begin
  Assert.AreEqual(0, GameBowling.TotalScore);
end;

procedure TTestGame.BowlingGameInstantiate;
begin
  Assert.IsNotNull(GameBowling);
end;

procedure TTestGame.BowlingGamePerfect;
var
  I: Integer;
begin
  for I := 1 to 12 do
  begin
    GameBowling.Roll(10);
  end;
  Assert.AreEqual(300, GameBowling.TotalScore);
end;

procedure TTestGame.BowlingGameRollCount(const ARolls, OResult: Integer);
var
  I: Integer;
begin
  for I := 1 to ARolls do
  begin
    GameBowling.Roll;
  end;
  Assert.AreEqual(OResult, GameBowling.TotalRolls);
end;

procedure TTestGame.BowlingGameRollFirst(const APinsDown: Integer; const OResult: Integer);
begin
  GameBowling.Roll(APinsDown);
  Assert.AreEqual(OResult, GameBowling.TotalScore);
end;

procedure TTestGame.BowlingGameRollTwo(const APinsDown1, APinsDown2,
  OResult: Integer);
begin
  GameBowling.Roll(APinsDown1);
  GameBowling.Roll(APinsDown2);
  //GameBowling.Roll;
  Assert.AreEqual(OResult, GameBowling.TotalScore);
end;

procedure TTestGame.Setup;
begin
  GameBowling := TGame.Create;
end;

procedure TTestGame.TearDown;
begin
end;

procedure TTestGame.Test1;
begin
end;

procedure TTestGame.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestGame);
end.
