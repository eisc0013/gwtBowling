program gwtBowling;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  uBowling in 'uBowling.pas',
  uExampleHelpers in 'uExampleHelpers.pas';

var
  GameBowling: IGame;
  MenuChoice: Integer;

begin
  try
    GameBowling := TGame.Create;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': Could not create GameBowling', E.Message);
  end;

  MenuChoice := Menu;
  while (MenuChoice <> 3) do
  begin
    GameBowling.Start;
    case MenuChoice of
    1:
    begin
    BowlingAuto(GameBowling);
    BowlingResultsPrint(GameBowling);
    end;
    2:
    begin
    BowlingManual(GameBowling);
    BowlingResultsPrint(GameBowling);
    end;
    end;


    MenuChoice := Menu;
  end;
end.
