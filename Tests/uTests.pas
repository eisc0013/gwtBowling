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
    [TestCase('OneFrame', '5,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,5')]
    procedure BowlingGameRollAll(const APinsDown1, APinsDown2, APinsDown3,
     APinsDown4, APinsDown5, APinsDown6, APinsDown7, APinsDown8, APinsDown9,
     APinsDown10, APinsDown11, APinsDown12, APinsDown13, APinsDown14, APinsDown15,
     APinsDown16, APinsDown17, APinsDown18, APinsDown19, APinsDown20, APinsDown21
     : Integer; const OResult: Integer);
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

procedure TTestGame.BowlingGameRollAll(const APinsDown1, APinsDown2, APinsDown3,
  APinsDown4, APinsDown5, APinsDown6, APinsDown7, APinsDown8, APinsDown9,
  APinsDown10, APinsDown11, APinsDown12, APinsDown13, APinsDown14, APinsDown15,
  APinsDown16, APinsDown17, APinsDown18, APinsDown19, APinsDown20, APinsDown21,
  OResult: Integer);
begin
  GameBowling.Roll(APinsDown1);
  GameBowling.Roll(APinsDown2);
  GameBowling.Roll(APinsDown3);
  GameBowling.Roll(APinsDown4);
  GameBowling.Roll(APinsDown5);
  GameBowling.Roll(APinsDown6);
  GameBowling.Roll(APinsDown7);
  GameBowling.Roll(APinsDown8);
  GameBowling.Roll(APinsDown9);
  GameBowling.Roll(APinsDown10);
  GameBowling.Roll(APinsDown11);
  GameBowling.Roll(APinsDown12);
  GameBowling.Roll(APinsDown13);
  GameBowling.Roll(APinsDown14);
  GameBowling.Roll(APinsDown15);
  GameBowling.Roll(APinsDown16);
  GameBowling.Roll(APinsDown17);
  GameBowling.Roll(APinsDown18);
  GameBowling.Roll(APinsDown19);
  GameBowling.Roll(APinsDown20);
  GameBowling.Roll(APinsDown21);
  Assert.AreEqual(OResult, GameBowling.TotalScore);
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
