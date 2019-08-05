program gwtBowling;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uBowling in 'uBowling.pas';

var
  GameBowling: IGame;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    GameBowling := TGame.Create;
  except
    on E: Exception do
      Writeln(E.ClassName, ': Could not create GameBowling', E.Message);
  end;
end.
