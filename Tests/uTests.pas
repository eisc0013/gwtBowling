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
  Assert.AreEqual(-1, GameBowling.TotalScore);
end;

procedure TTestGame.BowlingGameInstantiate;
begin
  Assert.IsNotNull(GameBowling);
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
