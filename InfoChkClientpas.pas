unit InfoChkClientpas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.StdCtrls, FMX.Header,
  FMX.Controls.Presentation, 
  MemDS, DBAccess, Uni, Data.DB, UniProvider, MySQLUniProvider;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Panel4: TPanel;
    StringGrid1: TStringGrid;
    UniConnection1: TUniConnection;
    UniQuery1: TUniQuery;
    MySQLUniProvider1: TMySQLUniProvider;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    // procedure StringGrid1ApplyStyleLookup(Sender:TObject);   //프로시져 추가할때 참고할것..
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawColumnCell(Sender: TObject; const Canvas: TCanvas;
      const Column: TColumn; const Bounds: TRectF; const Row: Integer;
      const Value: TValue; const State: TGridDrawStates);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure MemLoginChk;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.iPhone55in.fmx IOS}

procedure TForm1.Button1Click(Sender: TObject);
var
  chkBtn, i: integer;
  sAdd: string;
begin

  chkBtn := 0;
  if CheckBox1.IsChecked then
    chkBtn := chkBtn + 100;
  if CheckBox2.IsChecked then
    chkBtn := chkBtn + 10;
  if CheckBox3.IsChecked then
    chkBtn := chkBtn + 1;

  if chkBtn > 0 then
  begin

    if NOT UniConnection1.Connected then
      UniConnection1.Connected := True;
    with UniQuery1 do
    begin
      if chkBtn = 1 then
        sAdd := 'SV'
      else if chkBtn = 10 then
        sAdd := 'VI'
      else if chkBtn = 100 then
        sAdd := 'NW'
      else if chkBtn = 11 then
        sAdd := 'SV'',''VI'
      else if chkBtn = 101 then
        sAdd := 'NW'',''SV'
      else if chkBtn = 110 then
        sAdd := 'NW'',''VI'
      else
        sAdd := 'NW'',''SV'',''VI';

      Close;
      SQL.Clear;
      SQL.Add('SELECT machine,gubun,case WHEN chknow = ''Y'' then ''정상'' else ''오류'' end as CHK,bigo FROM infochk_machine ');
      SQL.Add(' WHERE gubun in ( ''' + sAdd + ''' ) ');
      SQL.Add(' ORDER BY gubun,machine ');
      OPEN;
      i := 0;
      while NOT EOF do
      begin

        StringGrid1.RowCount := i + 1;
        StringGrid1.Cells[0, i] := FieldByName('machine').AsString;
        StringGrid1.Cells[1, i] := FieldByName('gubun').AsString;
        StringGrid1.Cells[2, i] := FieldByName('CHK').AsString;
        StringGrid1.Cells[3, i] := FieldByName('bigo').AsString;
        inc(i);
        NEXT;
      end;
    end;


    StringGrid1.Columns[0].Width := Round(Form1.Width/100*25);
    StringGrid1.Columns[1].Width := Round(Form1.Width/100*15);
    StringGrid1.Columns[2].Width := Round(Form1.Width/100*15);
    StringGrid1.Columns[3].Width := Round(Form1.Width/100*45);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  StringGrid1.AddObject(TStringColumn.Create(Self));
  StringGrid1.AddObject(TStringColumn.Create(Self));
  StringGrid1.AddObject(TStringColumn.Create(Self));
  StringGrid1.AddObject(TStringColumn.Create(Self));
  StringGrid1.Columns[0].Header := '명칭';
  StringGrid1.Columns[1].Header := '구분';
  StringGrid1.Columns[2].Header := '상태';
  StringGrid1.Columns[3].Header := '비고';


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // StringGrid1.OnApplyStyleLookup:= StringGrid1ApplyStyleLookup;
end;

procedure TForm1.MemLoginChk;
begin
  if NOT UniConnection1.Connected then
    UniConnection1.Connected := True;

  with UniQuery1 do
  begin
    //
  end;
end;

procedure TForm1.StringGrid1DrawColumnCell(Sender: TObject;
  const Canvas: TCanvas; const Column: TColumn; const Bounds: TRectF;
  const Row: Integer; const Value: TValue; const State: TGridDrawStates);
var
  RowColor : TBrush;
begin
  RowColor := TBrush.Create(TBrushKind.Solid,TAlphaColors.Alpha);
  if Value.ToString='Y' then RowColor.Color := TAlphaColors.Red;

//  Canvas.FillRect(Bounds,0,0,[],1,RowColor);
//  TGrid(Sender).DefaultDrawColumnCell(canvas,column,Bounds,Row,Value,State);
end;

{ //프로시져 추가할때 참고할것..
  procedure TForm1.StringGrid1ApplyStyleLookup(Sender: TObject);
  var  H:THeader;
  T:THeaderItem;
  A:Integer;
  begin
  if StringGrid1.FindStyleResource<THeader>('header', H) then
  begin
  H.Height := 30;
  for A:=0 to H.Count-1 do
  begin
  T:=THeaderItem(H.Items[A]);
  T.StyledSettings:=[TStyledSetting.FontColor];
  T.TextSettings.HorzAlign:=TTextAlign.Center;
  //        T.TextSettings.FontColor:=TAlphacolors.Yellow;
  T.TextSettings.Font.Family := '굴림체';
  T.TextSettings.Font.Size:=20;
  end;
  end;

  end;
}
end.
