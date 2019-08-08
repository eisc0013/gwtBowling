unit uTests;

interface
uses
  SysUtils, DUnitX.TestFramework, uBowling;

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
    [TestCase('Strike', '10,-1')]
    procedure BowlingGameRollFirst(const APinsDown: Integer; const OResult: Integer);
    [Test]
    [TestCase('Spare', '5,5,-1')]
    procedure BowlingGameRollTwo(const APinsDown1: Integer; const APinsDown2: Integer; const OResult: Integer);
    [Test]
    [TestCase('Five', '5,5')]
    procedure BowlingGameRollCount(const ARolls: Integer; const OResult: Integer);
    [Test]
    [TestCase('OneFrame', '5,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,5')]
    [TestCase('TwoFrames', '6,4,3,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,17')]
    [TestCase('SixFrames', '6,4,3,1,10,-1,10,-1,10,-1,5,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,92')]
    [TestCase('SixFramesAlternate', '6,4,3,1,10,10,10,5,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,92')]
    [TestCase('SevenFramesIndeterminate', '6,4,3,1,10,10,10,5,0,10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1')]
    [TestCase('FullGame10th2Strikes', '10,10,10,10,10,10,10,10,10,10,10,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,291')]
    [TestCase('FullGame10th1StrikeA', '10,10,10,10,10,10,10,10,10,10,1,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,273')]
    [TestCase('FullGame10th1StrikeB', '10,10,10,10,10,10,10,10,10,5,5,10,-1,-1,-1,-1,-1,-1,-1,-1,-1,275')]
    [TestCase('FullGame10th1StrikeC', '10,10,10,10,10,10,10,10,10,10,5,5,-1,-1,-1,-1,-1,-1,-1,-1,-1,285')]
    procedure BowlingGameRollAll(const APinsDown1, APinsDown2, APinsDown3,
     APinsDown4, APinsDown5, APinsDown6, APinsDown7, APinsDown8, APinsDown9,
     APinsDown10, APinsDown11, APinsDown12, APinsDown13, APinsDown14, APinsDown15,
     APinsDown16, APinsDown17, APinsDown18, APinsDown19, APinsDown20, APinsDown21
     : Integer; const OResult: Integer);
    [Test]
    [TestCase('TooManyPins', '20')]
    procedure BowlingGameTooManyPins(const APinsDown: Integer);
    [Test]
    procedure BowlingGameTooManyRolls;
    [Test]
    procedure BowlingGameRandomRollException;
    [Test]
    procedure BowlingGamePerfect;
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

procedure TTestGame.BowlingGameRandomRollException;
var
  I: Integer;
begin
  for I := 1 to 12 do
  begin
    GameBowling.Roll(10);
  end;
  // ALE 20190807 bad things should happen on 13th roll
  Assert.WillRaiseWithMessage(
   procedure begin GameBowling.Roll; end, Exception, 'Roll: Bowling alley is broken');
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

procedure TTestGame.BowlingGameTooManyPins(const APinsDown: Integer);
begin
  Assert.WillRaiseWithMessage(
   procedure begin GameBowling.Roll(APinsDown); end, Exception, 'Max of 10 pins man');
end;

procedure TTestGame.BowlingGameTooManyRolls;
var
  I: Integer;
begin
  for I := 1 to 12 do
  begin
    GameBowling.Roll(10);
  end;
  // ALE 20190807 bad things should happen on 13th roll
  Assert.WillRaiseWithMessage(
   procedure begin GameBowling.Roll(0); end, Exception, 'Game is already over man');
end;

procedure TTestGame.Setup;
begin
  GameBowling := TGame.Create;
end;

procedure TTestGame.TearDown;
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestGame);
end.
