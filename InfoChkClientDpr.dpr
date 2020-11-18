program InfoChkClientDpr;

uses
  System.StartUpCopy,
  FMX.Forms,
  InfoChkClientpas in 'InfoChkClientpas.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
